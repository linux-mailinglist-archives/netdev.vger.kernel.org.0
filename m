Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FF1985AF
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbfHUUfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:35:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58426 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730350AbfHUUfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 16:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=h8TK8tJO12hCur69g15XAWCcRJ/DOuxKXN/zHUhvQpA=; b=P+F+IQh3L9XpQ/tMDsb85XvO8
        OtgCWejTkI1LKZ5sqHV/yiMkM8oROfG94MZbbwED7h6BU+fhCYGPO2VLYeID8qkg2J9Gi1RfOfBKc
        XYQW/PSME4Zgc7Yemc3K8McGi2e0fA1VGtJ+8w1M6j0AleN5PIEZLdKynmP1145BRdinHXtuFhyGH
        ug4weq1zklGKIQCdZB3JgsN/4/OXqyzfutoDbqkBNJXQsQrSKFpA+tq++jO2D7eaUTlDdX7j+xqtE
        s+PP/qfyDlE/ntJLLUfCg0Mn3I30b2t9I1oKJho1yNgCrSERIe9yfra5HT68JwV9dfAK9Ncynj3Df
        D4FY3b8lQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0XK6-0005yx-F6; Wed, 21 Aug 2019 20:35:14 +0000
Date:   Wed, 21 Aug 2019 13:35:14 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 33/38] act_api: Convert action_idr to XArray
Message-ID: <20190821203514.GA21442@bombadil.infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
 <20190820223259.22348-34-willy@infradead.org>
 <vbfpnky4884.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vbfpnky4884.fsf@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 07:41:19PM +0000, Vlad Buslov wrote:
> > @@ -301,18 +292,18 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
> >  	if (nla_put_string(skb, TCA_KIND, ops->kind))
> >  		goto nla_put_failure;
> >  
> > -	mutex_lock(&idrinfo->lock);
> > -	idr_for_each_entry_ul(idr, p, tmp, id) {
> > +	xa_lock(&idrinfo->actions);
> > +	xa_for_each(&idrinfo->actions, index, p) {
> >  		ret = tcf_idr_release_unsafe(p);
> 
> I like the simplification of reusing builtin xarray spinlock for this,
> but the reason we are using mutex here is because the following call
> chain: tcf_idr_release_unsafe() -> tcf_action_cleanup() -> free_tcf() ->
> tcf_chain_put_by_act() -> __tcf_chain_put() -> mutex_lock(&block->lock);

Ah, this one is buggy anyway because we call xa_erase() inside the
loop, so it'll deadlock.

We could just drop the xa_lock() / xa_unlock() around the loop.  There's
no need to hold the lock unless we're trying to prevent other simultaneous
additions/deletions, which shouldn't be happening?  ie this:

@@ -268,8 +268,10 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
        if (atomic_read(&p->tcfa_bindcnt) > 0)
                return -EPERM;
 
-       if (refcount_dec_and_test(&p->tcfa_refcnt)) {
-               xa_erase(&p->idrinfo->actions, p->tcfa_index);
+       if (refcount_dec_and_lock(&p->tcfa_refcnt,
+                                       &p->idrinfo->actions.xa_lock)) {
+               __xa_erase(&p->idrinfo->actions, p->tcfa_index);
+               xa_unlock(&p->idrinfo->actions);
                tcf_action_cleanup(p);
                return ACT_P_DELETED;
        }
@@ -292,18 +294,15 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
        if (nla_put_string(skb, TCA_KIND, ops->kind))
                goto nla_put_failure;
 
-       xa_lock(&idrinfo->actions);
        xa_for_each(&idrinfo->actions, index, p) {
                ret = tcf_idr_release_unsafe(p);
                if (ret == ACT_P_DELETED) {
                        module_put(ops->owner);
                        n_i++;
                } else if (ret < 0) {
-                       xa_unlock(&idrinfo->actions);
                        goto nla_put_failure;
                }
        }
-       xa_unlock(&idrinfo->actions);
 
        if (nla_put_u32(skb, TCA_FCNT, n_i))
                goto nla_put_failure;


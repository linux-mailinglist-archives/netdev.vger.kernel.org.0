Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E0D27B52F
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgI1TVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:21:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34301 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbgI1TVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:21:48 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601320907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y84J19RBiHtrF+ZCOt3RqJAf/EqA0hstnJ8ucx9jVeo=;
        b=eTVcHPtRa8iGl22fodm5uIZgIfbVeiA6pLBgxlL/1aBi/a8OsOLKyVmMlD2sHpNf2YSGZV
        sRzSRp5LwyrA7UbR1Ld1tMG3yjiShzxi8IxEErcnzPBkCtrx68KLyo2uXt7HzH0knk/Xw1
        pSLqcx9KjUUT55a1YXzniYTl4u7/GmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-p-TbYFN7Oq2OadJ-tWnsKA-1; Mon, 28 Sep 2020 15:21:45 -0400
X-MC-Unique: p-TbYFN7Oq2OadJ-tWnsKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D237A1005513;
        Mon, 28 Sep 2020 19:21:43 +0000 (UTC)
Received: from ceranb (unknown [10.40.195.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C26C805D2;
        Mon, 28 Sep 2020 19:21:42 +0000 (UTC)
Date:   Mon, 28 Sep 2020 21:21:42 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 1/2] netlink: return -ENOMEM when calloc fails
Message-ID: <20200928212142.03afa116@ceranb>
In-Reply-To: <20200928154455.hi6767brao7p4ac5@lion.mk-sys.cz>
References: <20200924192758.577595-1-ivecera@redhat.com>
        <20200928154455.hi6767brao7p4ac5@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Sep 2020 17:44:55 +0200
Michal Kubecek <mkubecek@suse.cz> wrote:

> On Thu, Sep 24, 2020 at 09:27:57PM +0200, Ivan Vecera wrote:
> > Fixes: f2c17e107900 ("netlink: add netlink handler for gfeatures (-k)")
> > 
> > Cc: Michal Kubecek <mkubecek@suse.cz>
> > Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> > ---
> >  netlink/features.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/netlink/features.c b/netlink/features.c
> > index 3f1240437350..b2cf57eea660 100644
> > --- a/netlink/features.c
> > +++ b/netlink/features.c
> > @@ -112,16 +112,17 @@ int dump_features(const struct nlattr *const *tb,
> >  	unsigned int *feature_flags = NULL;
> >  	struct feature_results results;
> >  	unsigned int i, j;
> > -	int ret;
> > +	int ret = 0;
> >  
> >  	ret = prepare_feature_results(tb, &results);
> >  	if (ret < 0)
> >  		return -EFAULT;
> >  
> > -	ret = -ENOMEM;
> >  	feature_flags = calloc(results.count, sizeof(feature_flags[0]));
> > -	if (!feature_flags)
> > +	if (!feature_flags) {
> > +		ret = -ENOMEM;
> >  		goto out_free;
> > +	}
> >  
> >  	/* map netdev features to legacy flags */
> >  	for (i = 0; i < results.count; i++) {
> > @@ -184,7 +185,7 @@ int dump_features(const struct nlattr *const *tb,
> >  
> >  out_free:
> >  	free(feature_flags);
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  int features_reply_cb(const struct nlmsghdr *nlhdr, void *data)
> > -- 
> > 2.26.2  
> 
> The patch is correct but relying on ret staying zero through the whole
> function is rather fragile (it could break when adding more checks in
> the future) and it also isn't consistent with the way this is done in
> other functions.
> 
> AFAICS you could omit the first hunk and just add "ret = 0" above the
> out_free label.
> 
> Michal

OK, will do.

Ivan


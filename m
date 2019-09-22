Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B198BBA032
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 04:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfIVCIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 22:08:05 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40933 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfIVCIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 22:08:04 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so6915066pfb.7
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 19:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Kvb66r57EbPQuEiewVEGLwLX8v0Dn7y42rkkDZUtJHM=;
        b=RnTt5UC5Rcofn9wYV3uTNd+zxkWyoijWFwK/pVRO8CYuLNRzMjVsEBDJGiB8cNdmKZ
         WJcsCdQ9TNStBktqDvN/MCvvX+w6NItqK5UhlRld475uDyRlKcgaMbvcR7XLtULNbehY
         GGcRI4HqwVhbB7jxlREzydaIVTVJrTQegRBpP2vfvU7ok2D2J1uhDmBgv+m+MTcWuoo7
         hXWgF57qmdR4Onku2r8pGVyWAuwgURElbRThys6GTw9tXi7i5ONNnqWB4dyjcYRDBMYS
         OQxUnkkNHPKoMAExRlxiQRnHAt73JyQJKNFNO0BJYzaZlXNCTmKrk/jwvO4rJL57omqD
         TYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Kvb66r57EbPQuEiewVEGLwLX8v0Dn7y42rkkDZUtJHM=;
        b=SQRBr55Ju79QbcLiT2OS30mFzFhLkZZ4whucVGq2mUj94DUbAv/yHMikhouxhDHyoE
         d7JyHZ4DuowxMJXahA5ASggLgMS9f980jOZ8zMlow0tn9KVmS9DVJduxBzJliFqRXJz4
         e2TdU+PPij9ZIn/wt5idEJDr1BMv6P4eP2gKlF92MihQzg4xLgV8p72Qi/NgLNaKQcwS
         1V9ow23ysgX33PPTeWK5OWGATZB2SzGoE3LfePpJE2NcxkZGMLCIC5mBYlFRnnMdeSmp
         5WP6s1UZvuI1nEI6U+2P3/THy+URg5sDbP14trRHX4Ac3atYdwcgeeQItyGPYwNqCfgw
         zlGw==
X-Gm-Message-State: APjAAAVLd6PNZgm97ZRLJXFmdDPBfiOGyZjaE73uOANoa/znG/qAGc1r
        1rFGdzBn+7B+WJq30Nt+gC92Xw==
X-Google-Smtp-Source: APXvYqz4xtGA7N/n0ha/z2AbiyyhCvU/mMuFmOOTbWqndkyKsDJX/n2NKU9RD6QCS1/9dZ1CZReoHw==
X-Received: by 2002:a62:e917:: with SMTP id j23mr11164022pfh.50.1569118084076;
        Sat, 21 Sep 2019 19:08:04 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 192sm2075279pfb.110.2019.09.21.19.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 19:08:03 -0700 (PDT)
Date:   Sat, 21 Sep 2019 19:08:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net] net: sched: fix possible crash in
 tcf_action_destroy()
Message-ID: <20190921190800.3f19fe23@cakuba.netronome.com>
In-Reply-To: <CAM_iQpVyJDeScQDL6vHNAN9gu5a3c0forQ2Ko7eQihawRO_Sdw@mail.gmail.com>
References: <20190918195704.218413-1-edumazet@google.com>
        <CAM_iQpVyJDeScQDL6vHNAN9gu5a3c0forQ2Ko7eQihawRO_Sdw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Sep 2019 14:37:21 -0700, Cong Wang wrote:
> On Wed, Sep 18, 2019 at 12:57 PM 'Eric Dumazet' via syzkaller
> <syzkaller@googlegroups.com> wrote:
> >
> > If the allocation done in tcf_exts_init() failed,
> > we end up with a NULL pointer in exts->actions.  
> ...
> > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> > index efd3cfb80a2ad775dc8ab3c4900bd73d52c7aaad..9aef93300f1c11791acbb9262dfe77996872eafe 100644
> > --- a/net/sched/cls_api.c
> > +++ b/net/sched/cls_api.c
> > @@ -3027,8 +3027,10 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
> >  void tcf_exts_destroy(struct tcf_exts *exts)
> >  {
> >  #ifdef CONFIG_NET_CLS_ACT
> > -       tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
> > -       kfree(exts->actions);
> > +       if (exts->actions) {  
> 
> I think it is _slightly_ better to check exts->nr_actions!=0 here,
> as it would help exts->actions!=NULL&& exts->nr_actions==0
> cases too.
> 
> What do you think?

Alternatively, since tcf_exts_destroy() now takes NULL, and so
obviously does kfree() - perhaps tcf_action_destroy() should 
return early if actions are NULL?

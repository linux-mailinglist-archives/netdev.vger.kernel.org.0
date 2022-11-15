Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F1F62A19C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 19:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiKOS7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 13:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiKOS7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 13:59:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A47E28E15
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 10:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668538690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZhhMRXuffKWmJnSyDCn2McoLOIVtIOCGZv8DUDNnMo8=;
        b=hlCUhVwKrCsMyIm2bLvwHUxd3OgW1/pK7zIu/GJyitMN59v1CAlSzE3yN0s+UqHWC8x1Um
        YgcNztraDwFlJkzCEsaG6ebEfsmCZz6Ct+n5GTRJ9YiMI7A0TWN5EPmB/u40QegUW/uf0N
        rU1HJTa3e/YXNFxNxMUIZMXU0Sg0P58=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-267-M1P_IgOQPHiI_JH_3M4I7g-1; Tue, 15 Nov 2022 13:57:21 -0500
X-MC-Unique: M1P_IgOQPHiI_JH_3M4I7g-1
Received: by mail-qv1-f72.google.com with SMTP id nn2-20020a056214358200b004bb7bc3dfdcso11397602qvb.23
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 10:57:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZhhMRXuffKWmJnSyDCn2McoLOIVtIOCGZv8DUDNnMo8=;
        b=HVzNJFkfMnkJc8AeOciSZEVE1T4JvOggS/AyQ6ESBxjsr0WowPZS4ULi0G7zgeZPTU
         SykiC8sBTVDtMh+I46XGQXakG5KNGK+GeY/9G5BKr31hFTux/z2l0o36Ci0REDiNajnZ
         P3GISJ9xmg0zu6WII/ONz824AJmOgr3TOwKkJFujvTac2WYtZkfAfXgz5rB1xQ8W0ZQw
         FYj0jZUrzYypzzQ77T/azxiSjK0ztScBwi7Y1xMz7njRO7Vgg/3JRsRQmx0pMdzHVU+U
         XcsvECDFxr/iDD/nr/l44yPMlKMy3zJrBQQCvo3ANhaWK5VsDBgBYQycQuSRl6oYJvzG
         Bfpw==
X-Gm-Message-State: ANoB5pm3+1asnmeTbvJlUViBP3qreX+hCdMemqLeEGEeggrjfX+phENK
        uULgtjsB7fijUYAwdV2628iaJyNFOjZmNimoh87u0oUvqRsvp3n1nemZw5eI5XyaDeGKXfyd+Hs
        OT41Pxpe4DvPgaHRU
X-Received: by 2002:ae9:df02:0:b0:6fa:349b:7ba9 with SMTP id t2-20020ae9df02000000b006fa349b7ba9mr16439644qkf.339.1668538637521;
        Tue, 15 Nov 2022 10:57:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7GD+tyKObY1rdcIBVv/8GoCtuT4sd5/XvTzrz7bCmBtCQN9hqUquK8/onwIkjV5MLTbXaA0g==
X-Received: by 2002:ae9:df02:0:b0:6fa:349b:7ba9 with SMTP id t2-20020ae9df02000000b006fa349b7ba9mr16439513qkf.339.1668538634735;
        Tue, 15 Nov 2022 10:57:14 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id l6-20020a05620a210600b006ce1bfbd603sm8460405qkl.124.2022.11.15.10.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 10:57:14 -0800 (PST)
Message-ID: <bc4616002932b25973533c39c07f48ea57afa3dc.camel@redhat.com>
Subject: Re: [PATCH v2] net: sched: fix memory leak in tcindex_set_parms
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Hawkins Jiawei <yin31149@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, 18801353760@163.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 15 Nov 2022 19:57:10 +0100
In-Reply-To: <20221115090237.5d5988bb@kernel.org>
References: <20221113170507.8205-1-yin31149@gmail.com>
         <20221115090237.5d5988bb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-11-15 at 09:02 -0800, Jakub Kicinski wrote:
> On Mon, 14 Nov 2022 01:05:08 +0800 Hawkins Jiawei wrote:
> 
> > @@ -479,6 +480,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >  	}
> >  
> >  	if (old_r && old_r != r) {
> > +		old_e = old_r->exts;
> >  		err = tcindex_filter_result_init(old_r, cp, net);
> >  		if (err < 0) {
> >  			kfree(f);
> > @@ -510,6 +512,12 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >  		tcf_exts_destroy(&new_filter_result.exts);
> >  	}
> >  
> > +	/* Note: old_e should be destroyed after the RCU grace period,
> > +	 * to avoid possible use-after-free by concurrent readers.
> > +	 */
> > +	synchronize_rcu();
> > +	tcf_exts_destroy(&old_e);
> 
> I don't think this dance is required, @cp is a copy of the original
> data, and the original (@p) is destroyed in a safe manner below.

This code confuses me more than a bit, and I don't follow ?!? it looks
like that at this point:

* the data path could access 'old_r->exts' contents via 'p' just before
the previous 'tcindex_filter_result_init(old_r, cp, net);' but still
potentially within the same RCU grace period

* 'tcindex_filter_result_init(old_r, cp, net);' has 'unlinked' the old
exts from 'p'  so that will not be freed by later
tcindex_partial_destroy_work() 

Overall it looks to me that we need some somewhat wait for the RCU
grace period, 

Somewhat side question: it looks like that the 'perfect hashing' usage
is the root cause of the issue addressed here, and very likely is
afflicted by other problems, e.g. the data curruption in 'err =
tcindex_filter_result_init(old_r, cp, net);'.

AFAICS 'perfect hashing' usage is a sort of optimization that the user-
space may trigger with some combination of the tcindex arguments. I'm
wondering if we could drop all perfect hashing related code?

Paolo


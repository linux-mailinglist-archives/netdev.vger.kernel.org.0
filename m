Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D52F5721C6
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 19:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGLRbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 13:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGLRbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 13:31:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2065C1740
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 10:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657647075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xlt7tEF5MS5pxQiB3QIg/pvI4EFIsZBxEXSN0MrG/jw=;
        b=MB+aYLWxPsbFxri2wwNP2+oOksgcIGzQBqFElcNw3R9wHs+RV8RIUOTHoeWn297TVEm3QP
        AOEafUurTPyK2RPhI0siQ/gCHc8TYfHLc1IDmAvrBS/GYGvCEQZpIgeUmbMI1kTAvLdh/u
        NHZQ/R8r45nWjM2cI7Wi9RffFl4h1xA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-VQ7T69l5NtWdH4x_TOEvEA-1; Tue, 12 Jul 2022 13:31:14 -0400
X-MC-Unique: VQ7T69l5NtWdH4x_TOEvEA-1
Received: by mail-wr1-f69.google.com with SMTP id e7-20020adfa447000000b0021d669c6a76so1600200wra.19
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 10:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xlt7tEF5MS5pxQiB3QIg/pvI4EFIsZBxEXSN0MrG/jw=;
        b=JMKd/3yyOMmTewfztKDx7ktIcgmbL3Wo2wFIlcg/QZYuHeNsLOv3c2FH51mJ0R8L9g
         djQZaZjxQJc7ejancFIrg5b9Qb7uvipET1LqHvqtGblGZ+FzkYXF/5++NSYIy4DEW7M2
         wWWOrxzDIVPJqndkjGTe9zbb5FFj14GL6l9SiPlpFXVssSdQA0dWLAMosVvw1lbMigC8
         ogS5usnFoJbZ4seiY7mK09nu2XU7qi8UvDwpiAu978asDmnh4lHWRR961HOsDqsajK/4
         UsDMTcooz2mTU2jyaEP6fn+3n3a1zpPHiilJlsdrVhW47IdapbcYPGvWLJzcuxtMjGH4
         nZlQ==
X-Gm-Message-State: AJIora8bDqVroHdqOW+V9xCBpKhl6gatD5NkmA1/v5CAmSDbl89XxrQT
        jTVvvHn1Ep7Ga96pdLLaIYe6vcRaKL1AwSI8ygOGDZ1FE5B8cpuJwtBrg5mKVwaVC/XjXNH81po
        ElgIZ+F1qvX4Yxf+j
X-Received: by 2002:a05:600c:5013:b0:3a2:e7a0:a4e4 with SMTP id n19-20020a05600c501300b003a2e7a0a4e4mr5324536wmr.122.1657647073739;
        Tue, 12 Jul 2022 10:31:13 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s0r989U5Ouvj2bJIHS625Y9N7GUvbCsG3uzPYYcJStSYMmdiEh5m+vwinxrjEjYEN0fCfyTQ==
X-Received: by 2002:a05:600c:5013:b0:3a2:e7a0:a4e4 with SMTP id n19-20020a05600c501300b003a2e7a0a4e4mr5324494wmr.122.1657647073515;
        Tue, 12 Jul 2022 10:31:13 -0700 (PDT)
Received: from localhost.localdomain ([185.233.130.50])
        by smtp.gmail.com with ESMTPSA id g17-20020a05600c4ed100b003a2ed2a40e4sm3182733wmq.17.2022.07.12.10.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 10:31:13 -0700 (PDT)
Date:   Tue, 12 Jul 2022 19:31:10 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "zhangkaiheb@126.com" <zhangkaiheb@126.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "mostrows@earthlink.net" <mostrows@earthlink.net>,
        "paulus@samba.org" <paulus@samba.org>
Subject: Re: [RFC PATCH net-next v4 2/4] net/sched: flower: Add PPPoE filter
Message-ID: <20220712173110.GB3794@localhost.localdomain>
References: <20220708122421.19309-1-marcin.szycik@linux.intel.com>
 <20220708122421.19309-3-marcin.szycik@linux.intel.com>
 <20220708192253.GC3166@debian.home>
 <MW4PR11MB57763D75A50EF9CF369C0EDAFD879@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB57763D75A50EF9CF369C0EDAFD879@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 10:26:21AM +0000, Drewek, Wojciech wrote:
> > > +static void fl_set_key_pppoe(struct nlattr **tb,
> > > +			     struct flow_dissector_key_pppoe *key_val,
> > > +			     struct flow_dissector_key_pppoe *key_mask,
> > > +			     struct fl_flow_key *key,
> > > +			     struct fl_flow_key *mask)
> > > +{
> > > +	/* key_val::type must be set to ETH_P_PPP_SES
> > > +	 * because ETH_P_PPP_SES was stored in basic.n_proto
> > > +	 * which might get overwritten by ppp_proto
> > > +	 * or might be set to 0, the role of key_val::type
> > > +	 * is simmilar to vlan_key::tpid
> > 
> > Didn't you mean "vlan_tpid"?
> 
> Yes, is vlan_key::tpid not clear/valid?

At least it wasn't entirely clear to me as I wondered if I got the
comment right. And it's basically free to use the real name of the
structure field.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B702268305D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 16:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjAaPBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 10:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjAaPA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 10:00:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3952186AE
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675177182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+U/x98XOstDPcM5zMePGa9Q6kkEzFjB2KTbzTZ4PPUI=;
        b=MZnrn8n4/H8QUkJgpWMUL8nHP9fhftJPtE3aS+rdksQ9l7hsnGa6kZgkoh7AbSQymlmfUt
        1sDLXgbrX0LxG1hifY8FwOpPQpM8RS7PwE4Mxp/EaPeKzoS7VMdMgAaOxP5myYAJwzNScH
        DQ0fesm5QikvHGj1FF59pmKdjwIP0fI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-12-TrDq_j1rPHu5kjGhblhMJg-1; Tue, 31 Jan 2023 09:59:41 -0500
X-MC-Unique: TrDq_j1rPHu5kjGhblhMJg-1
Received: by mail-qv1-f70.google.com with SMTP id j12-20020a056214032c00b0053782e42278so7925741qvu.5
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:59:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+U/x98XOstDPcM5zMePGa9Q6kkEzFjB2KTbzTZ4PPUI=;
        b=TqLa4rtleiHihYxHZzZQ0McnvBVvtKMxOrIzGhZV1n2NoupU2rOxfmS197M7ylLsQ5
         bLW1bW1+9DrYQDDH/QpGbObt+KbPzjsZRMR6mLMiqHKEq1n1Q5Ta+BG0FO0nOITDIf2n
         NlWRPWDUNGwiash7FncopbMGxeCnAkcQvncW1v9d/5wjZqhugli7/pGDzYzqVWmSfQQJ
         D/ocqJVh2uOW6xpFy1asUtlTFs6f91U8i+mHsaGlQ0QiB4Co9QA7ajXq7nEOwbJT4+r7
         LHqn1EuymdLWND6iRfNAqZ5nifMlgg4viFMvFWb/VCfgJWyGofl0LdMMEyle2/uOvYcn
         WYAA==
X-Gm-Message-State: AO0yUKVYgiHEKLyS/ViyR1DHOs9RqzjJ306tS64/ZKMJ2BDNuAu6eUIL
        4rE3BPvmtqHEdC5k217sPATpR/5I3CsqOAQQIdX1lx2zLA66hhKNKjwgeRvfZLw7E4EkxepSDQ2
        vngMmDEpYHoA8YeEB
X-Received: by 2002:a05:622a:1143:b0:3b8:5f47:aac2 with SMTP id f3-20020a05622a114300b003b85f47aac2mr7227253qty.1.1675177180027;
        Tue, 31 Jan 2023 06:59:40 -0800 (PST)
X-Google-Smtp-Source: AK7set/uvCUHqLEib8MWW+Scxld4EXKmDa7qwl/YCIecZV1Kym67Uf4BU8KwccLUeXdAFEImrBVq3g==
X-Received: by 2002:a05:622a:1143:b0:3b8:5f47:aac2 with SMTP id f3-20020a05622a114300b003b85f47aac2mr7227215qty.1.1675177179789;
        Tue, 31 Jan 2023 06:59:39 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id 22-20020ac85616000000b003b86b5a07b3sm3723039qtr.90.2023.01.31.06.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 06:59:39 -0800 (PST)
Message-ID: <0601c53b3dc178293e05d87f75f481367ff4fd47.camel@redhat.com>
Subject: Re: [PATCHv4 net-next 09/10] net: add gso_ipv4_max_size and
 gro_ipv4_max_size per device
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Date:   Tue, 31 Jan 2023 15:59:34 +0100
In-Reply-To: <7e1f733cc96c7f7658fbf3276a90281b2f37acd1.1674921359.git.lucien.xin@gmail.com>
References: <cover.1674921359.git.lucien.xin@gmail.com>
         <7e1f733cc96c7f7658fbf3276a90281b2f37acd1.1674921359.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-01-28 at 10:58 -0500, Xin Long wrote:
> This patch introduces gso_ipv4_max_size and gro_ipv4_max_size
> per device and adds netlink attributes for them, so that IPV4
> BIG TCP can be guarded by a separate tunable in the next patch.
>=20
> To not break the old application using "gso/gro_max_size" for
> IPv4 GSO packets, this patch updates "gso/gro_ipv4_max_size"
> in netif_set_gso/gro_max_size() if the new size isn't greater
> than GSO_LEGACY_MAX_SIZE, so that nothing will change even if
> userspace doesn't realize the new netlink attributes.

Not a big deal, but I think it would be nice to include the pahole info
showing where the new fields are located and why that are good
locations.

No need to send a new version for just for the above, unless Eric asks
otherwise ;)

Cheers,

Paolo


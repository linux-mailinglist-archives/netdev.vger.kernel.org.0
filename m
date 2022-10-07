Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FCF5F79CC
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 16:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJGOjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 10:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiJGOjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 10:39:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C0621B0
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 07:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665153577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JOx3A6+XTaeuii+sjpdga3MYH7wwQtFa2GwJMRkhlp0=;
        b=GXzTgupT0sJEz8dbPPN1hUOl9jGtMO1Ncx++IzEXPRWb+YxmrvfIhBgUqJxF9t5MYUSnFo
        n5Dep/ItOX5gDfpAZ1Wjm3vVndpPGWO0aV+nw84/Gz9/caz8AdW8/EZhJdgTLg0jLCXfoK
        Leq7B0M1+e0QP2e4xFc9jtyL3ypSVR8=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-0dHlC4PEPjGNoTFT5y6dJg-1; Fri, 07 Oct 2022 10:39:36 -0400
X-MC-Unique: 0dHlC4PEPjGNoTFT5y6dJg-1
Received: by mail-yb1-f200.google.com with SMTP id y65-20020a25c844000000b006bb773548d5so4817732ybf.5
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 07:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JOx3A6+XTaeuii+sjpdga3MYH7wwQtFa2GwJMRkhlp0=;
        b=zNTMrbL3Ho7cG/joy2QX1TV14sgF3tF6r3Y3U1bDA6A/uldrFfvlcf0VfJ/Pk4S1/Z
         VDDaYyVgddaAOVHyteect1gQ6e0wjBtckPGdTYP4vxGD9muOBU+cbSQgviX4+yAUSuUI
         yQy9CTIjhMajgJNxgmPVHDBsieWKt17rqYVPF3HkQaTS6tN8sNzohKUuE0S804heUVEo
         yg2SDO2uX/7JvdesttFCuzIF4pG1oz54VaKdjT5+UQvNQGtJ/jDzdv8pYSQusqTdy68B
         t7zRi8pfdX24/d8p3fkXbuvgPTgFWfh75jxQoSaOPD9Adnt6IIJOiUJ99sej7eKie+9i
         iBig==
X-Gm-Message-State: ACrzQf1RIxzvW9RW0WBW5uPtU2BWd3QSKrS3+wE1D6KbyJSK0x0nI5pT
        ccooQToaONYzSpDUUXkM5CbYTd480xHRyDE9/KDE2y4kG0n0fcRup2KwPqFG2iJmLh0pBBw0bHT
        eS5KJrhqAbUaJZ/xifI4TQuZlIUdkv4dq
X-Received: by 2002:a25:40ce:0:b0:6be:79b3:51ac with SMTP id n197-20020a2540ce000000b006be79b351acmr4984723yba.635.1665153576323;
        Fri, 07 Oct 2022 07:39:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5kGmAkEKuaQ/uy01jcRcX7KaaEWRifn3GECX/tCBMwDjkw6bAu/NVD8fsnXMCa8IL1S+qgdfsbQUbQenxPvY4=
X-Received: by 2002:a25:40ce:0:b0:6be:79b3:51ac with SMTP id
 n197-20020a2540ce000000b006be79b351acmr4984702yba.635.1665153576089; Fri, 07
 Oct 2022 07:39:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220914141923.1725821-1-simon.horman@corigine.com>
 <eeb0c590-7364-a00e-69fc-2326678d6bdf@ovn.org> <PH0PR13MB4793A85169BB60B8609B192194499@PH0PR13MB4793.namprd13.prod.outlook.com>
 <0aac2127-0b14-187e-0adb-7d6b8fe8cfb1@ovn.org> <e71b2bf2-cfd5-52f4-5fd4-1c852f2a8c6c@ovn.org>
 <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com> <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
 <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
In-Reply-To: <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
From:   Davide Caratti <dcaratti@redhat.com>
Date:   Fri, 7 Oct 2022 16:39:25 +0200
Message-ID: <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload stats
To:     Marcelo Leitner <mleitner@redhat.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>,
        Simon Horman <simon.horman@corigine.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 7, 2022 at 3:21 PM Marcelo Leitner <mleitner@redhat.com> wrote:
>
> (+TC folks and netdev@)
>
> On Fri, Oct 07, 2022 at 02:42:56PM +0200, Ilya Maximets wrote:
> > On 10/7/22 13:37, Eelco Chaudron wrote:

[...]

> I don't see how we could achieve this without breaking much of the
> user experience.
>
> >
> > - or create something like act_count - a dummy action that only
> >   counts packets, and put it in every datapath action from OVS.
>
> This seems the easiest and best way forward IMHO. It's actually the
> 3rd option below but "on demand", considering that tc will already use
> the stats of the first action as the flow stats (in
> tcf_exts_dump_stats()), then we can patch ovs to add such action if a
> meter is also being used (or perhaps even always, because other
> actions may also drop packets, and for OVS we would really be at the
> 3rd option below).

Correct me if I'm wrong, but actually act_gact action with "pipe"
control action should already do this counting job.

any feedback appreciated, thanks!
-- 
davide


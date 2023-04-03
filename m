Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5136D4605
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjDCNnK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Apr 2023 09:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbjDCNnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:43:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708E4113F1
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 06:42:28 -0700 (PDT)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-i6FVCETGPqmxrZeetIExZg-1; Mon, 03 Apr 2023 09:42:26 -0400
X-MC-Unique: i6FVCETGPqmxrZeetIExZg-1
Received: by mail-ed1-f69.google.com with SMTP id m18-20020a50d7d2000000b00501dfd867a4so41649942edj.20
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 06:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OS4NCzI4dMmryLR3VX28JbtikJ9tRfdvXYd2DIsne/k=;
        b=JyNm2XFbOdzirewre3aetUOtSWg8Nvsq85u4I6Edztw0rRnryNYoO1BUoQuCEMXGws
         D4i5l0kRnFwfwp8Dg/3BUTGgg+iNAUr6untXTint+TsVSnoAWNXuI46uh7SPu3i55auV
         KB2KfAQJR3nLUAvkDQt+o8F7j7j2DjC+bp8nVRbcFAcgXhissQwXtBZeKGRhmqETFQ3l
         DDKLPOJPugTsco6wuYyz2rAYP4GWB52RLbkIrGLuWz3xfZtVwxACzYGpb2T2wcBRrBMB
         x4rA0o31kCgizc5nUsfwXTz9T5Hpi95t6yrWkb9CSxKEiGAcIR+o3Za8UimTV7ZuZBBt
         HEkw==
X-Gm-Message-State: AAQBX9dg9dh6LvvC2CpXcH9POP64p/Zz+LC/TjZfzpxBsretkkx3EyLN
        v4Y8a5UHdoZoRPey67pOVgB7ATocBcJtjut++UjTmKrsqzJjrzwVvzkoAO7sBkeRl99I8to4ZhY
        QiBTIP6I52dat0o+ATkTFfw0fBOmvMmtZ
X-Received: by 2002:a17:907:20bc:b0:92a:581:ac49 with SMTP id pw28-20020a17090720bc00b0092a0581ac49mr15782071ejb.3.1680529345226;
        Mon, 03 Apr 2023 06:42:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZS9NMl87IhXkFK8bF38G0BJCoJTDkYI0Flb56ddP0Lds2UzLtWXLCBUSsgQLOcelrjn/JtLl3IKiAL0t/rwSI=
X-Received: by 2002:a17:907:20bc:b0:92a:581:ac49 with SMTP id
 pw28-20020a17090720bc00b0092a0581ac49mr15782055ejb.3.1680529344974; Mon, 03
 Apr 2023 06:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230401172659.38508-1-mschmidt@redhat.com> <20230401172659.38508-3-mschmidt@redhat.com>
 <ZClkczf8EvDsPidF@corigine.com>
In-Reply-To: <ZClkczf8EvDsPidF@corigine.com>
From:   Michal Schmidt <mschmidt@redhat.com>
Date:   Mon, 3 Apr 2023 15:42:13 +0200
Message-ID: <CADEbmW1kvoqs3hAnPsrFRB3Emyf94_0WL=jt1QN+awZPCE50Cg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] ice: sleep, don't busy-wait, for sq_cmd_timeout
To:     Simon Horman <simon.horman@corigine.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Petr Oros <poros@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 2, 2023 at 1:18 PM Simon Horman <simon.horman@corigine.com> wrote:
> On Sat, Apr 01, 2023 at 07:26:57PM +0200, Michal Schmidt wrote:
> > The driver polls for ice_sq_done() with a 100 µs period for up to 1 s
> > and it uses udelay to do that.
> >
> > Let's use usleep_range instead. We know sleeping is allowed here,
> > because we're holding a mutex (cq->sq_lock). To preserve the total
> > max waiting time, measure cq->sq_cmd_timeout in jiffies.
> >
> > The sq_cmd_timeout is referenced also in ice_release_res(), but there
> > the polling period is 1 ms (i.e. 10 times longer). Since the timeout
> > was expressed in terms of the number of loops, the total timeout in this
> > function is 10 s. I do not know if this is intentional. This patch keeps
> > it.
> >
> > The patch lowers the CPU usage of the ice-gnss-<dev_name> kernel thread
> > on my system from ~8 % to less than 1 %.
> > I saw a report of high CPU usage with ptp4l where the busy-waiting in
> > ice_sq_send_cmd dominated the profile. The patch should help with that.
> >
> > Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_common.c   | 14 +++++++-------
> >  drivers/net/ethernet/intel/ice/ice_controlq.c |  9 +++++----
> >  drivers/net/ethernet/intel/ice/ice_controlq.h |  2 +-
> >  3 files changed, 13 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
> > index c2fda4fa4188..14cffe49fa8c 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_common.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> > @@ -1992,19 +1992,19 @@ ice_acquire_res(struct ice_hw *hw, enum ice_aq_res_ids res,
> >   */
> >  void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res)
> >  {
> > -     u32 total_delay = 0;
> > +     unsigned long timeout;
> >       int status;
> >
> > -     status = ice_aq_release_res(hw, res, 0, NULL);
> > -
> >       /* there are some rare cases when trying to release the resource
> >        * results in an admin queue timeout, so handle them correctly
> >        */
> > -     while ((status == -EIO) && (total_delay < hw->adminq.sq_cmd_timeout)) {
> > -             mdelay(1);
> > +     timeout = jiffies + 10 * hw->adminq.sq_cmd_timeout;
>
> Not needed for this series. But it occurs to me that a clean-up would be to
> use ICE_CTL_Q_SQ_CMD_TIMEOUT directly and remove the sq_cmd_timeout field,
> as it seems to be only set to that constant.

Simon,
You are right. I can do that in v2.
BTW, i40e and iavf are similar to ice here.
Thanks,
Michal


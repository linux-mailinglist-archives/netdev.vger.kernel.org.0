Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A8569E5C3
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbjBURR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbjBURR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:17:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500702E0F6;
        Tue, 21 Feb 2023 09:17:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E68E36115C;
        Tue, 21 Feb 2023 17:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0449C433EF;
        Tue, 21 Feb 2023 17:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676999844;
        bh=xBNVJdXxQw9xLa9bGh85+q7YfrToaQbE38ybZVRF5xc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Be/MU6I9UTNNMwxBwbz3Zv2y3jx3JhzRnuS1+eP4sGuIVDULaJSJUunBIoKoZD/+q
         pFch+6iKbVnGi9fJKoqXaOaiCzsKqe8Yka1Aptu1IlJsVibHwd7mS5FWHbcA3FZaDl
         EqKl0/YcC9sVLzfKiWSOQYdJU0e9AMY4xVjEQpYJWEmnXSbBptahCvvUa6yPCCKjmZ
         fiSe5YzW3RoggFM79q+zRLqUqV6TDGZaXzJn4l+e1yTKmSQpx6OeAwGu4g4+bThKZS
         HtqyeveUCMZNDveAJiiLEs1E15dgIRuy/mYWRvXPs+3qXmztH1W0tGnUCszjZRXA8X
         0d5J837h7lLsw==
Date:   Tue, 21 Feb 2023 09:20:52 -0800
From:   Bjorn Andersson <andersson@kernel.org>
To:     Sarannya S <quic_sarannya@quicinc.com>
Cc:     quic_bjorande@quicinc.com, arnaud.pouliquen@foss.st.com,
        swboyd@chromium.org, quic_clew@quicinc.com,
        mathieu.poirier@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        Deepak Kumar Singh <quic_deesin@quicinc.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:PTP HARDWARE CLOCK SUPPORT" <netdev@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Subject: Re: [PATCH V5 1/3] rpmsg: core: Add signal API support
Message-ID: <20230221172052.papcj7wl3u5gzo6s@ripper>
References: <1676990114-1369-1-git-send-email-quic_sarannya@quicinc.com>
 <1676990114-1369-2-git-send-email-quic_sarannya@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676990114-1369-2-git-send-email-quic_sarannya@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 08:05:12PM +0530, Sarannya S wrote:
> Some transports like Glink support the state notifications between
> clients using flow control signals similar to serial protocol signals.
> Local glink client drivers can send and receive flow control status
> to glink clients running on remote processors.
> 
> Add APIs to support sending and receiving of flow control status by
> rpmsg clients.
> 
> Signed-off-by: Deepak Kumar Singh <quic_deesin@quicinc.com>
> Signed-off-by: Sarannya S <quic_sarannya@quicinc.com>
> ---
>  arch/arm64/boot/Image.gz-dtb   | Bin 0 -> 12413735 bytes
>  drivers/rpmsg/rpmsg_core.c     |  20 ++++++++++++++++++++
>  drivers/rpmsg/rpmsg_core.c.rej |  11 +++++++++++
>  drivers/rpmsg/rpmsg_internal.h |   2 ++
>  include/linux/rpmsg.h          |  15 +++++++++++++++

Looks like you accidentally included the Image.gz-dtb and .rej file in
the patch. Please resend without these.

Thanks,
Bjorn

>  5 files changed, 48 insertions(+)
>  create mode 100644 arch/arm64/boot/Image.gz-dtb
>  create mode 100644 drivers/rpmsg/rpmsg_core.c.rej

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F871696B55
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbjBNRVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjBNRV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:21:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4C1E3;
        Tue, 14 Feb 2023 09:21:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D2AB61779;
        Tue, 14 Feb 2023 17:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5362C433EF;
        Tue, 14 Feb 2023 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676395282;
        bh=PqGwx2dYT6XLwA/BD+6gzTUQqPBIcR94mqfkmP5SHjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bWFtBcpAwOCoI2UGwpVx7yeWqM768vkfp0VCzVWKa0QyqGW14iJFwovPhiW5v3avR
         SZp0Ls/sziy7Gc9Sz35ffictb+hZ8u+FjSV20nA9gi3OkhbryERqI4Z9FJ64TBSgZ2
         bsf7rbsuBdJaGCKKqOr4+Xb4kZn27d+X3M/Qv2+2Muip0+ueICVVTXnnS1alg0RUxs
         DOfWrTBU5YYLHPUEfpUcyhO+3CrhO5+P+3IGIArTK7QeK1wA+eY6CwAuk/NHVtLAAB
         +2ce18ol06uxO4HHiKu9SeZHNxkxVgKlPZVO1gu8kd0aNMZ8esV3oyrPhNCjWdg4QR
         Vf3NZ+lkmPqGA==
Date:   Tue, 14 Feb 2023 09:23:25 -0800
From:   Bjorn Andersson <andersson@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Elliot Berman <quic_eberman@quicinc.com>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org
Subject: Re: [PATCH] firmware: qcom_scm: Use fixed width src vm bitmap
Message-ID: <20230214172325.lplxgbprhj3bzvr3@ripper>
References: <20230213181832.3489174-1-quic_eberman@quicinc.com>
 <20230213214417.mtcpeultvynyls6s@ripper>
 <Y+tNRPf0PGdShf5l@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+tNRPf0PGdShf5l@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 09:58:44AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Feb 13, 2023 at 01:44:17PM -0800, Bjorn Andersson wrote:
> > On Mon, Feb 13, 2023 at 10:18:29AM -0800, Elliot Berman wrote:
> > > The maximum VMID for assign_mem is 63. Use a u64 to represent this
> > > bitmap instead of architecture-dependent "unsigned int" which varies in
> > > size on 32-bit and 64-bit platforms.
> > > 
> > > Acked-by: Kalle Valo <kvalo@kernel.org> (ath10k)
> > > Tested-by: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>
> > > Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> > 
> > Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> > 
> > @Greg, would you mind taking this through your tree for v6.3, you
> > already have a related change in fastrpc.c in your tree...
> 
> I tried, but it doesn't apply to my char-misc tree at all:
> 
> checking file drivers/firmware/qcom_scm.c
> Hunk #1 succeeded at 898 (offset -7 lines).
> Hunk #2 succeeded at 915 (offset -7 lines).
> Hunk #3 succeeded at 930 (offset -7 lines).
> checking file drivers/misc/fastrpc.c
> checking file drivers/net/wireless/ath/ath10k/qmi.c
> checking file drivers/remoteproc/qcom_q6v5_mss.c
> Hunk #1 succeeded at 227 (offset -8 lines).
> Hunk #2 succeeded at 404 (offset -10 lines).
> Hunk #3 succeeded at 939 with fuzz 1 (offset -28 lines).
> checking file drivers/remoteproc/qcom_q6v5_pas.c
> Hunk #1 FAILED at 94.
> 1 out of 1 hunk FAILED
> checking file drivers/soc/qcom/rmtfs_mem.c
> Hunk #1 succeeded at 30 (offset -1 lines).
> can't find file to patch at input line 167
> Perhaps you used the wrong -p or --strip option?
> The text leading up to this was:
> --------------------------
> |diff --git a/include/linux/firmware/qcom/qcom_scm.h
> b/include/linux/firmware/qcom/qcom_scm.h
> |index 1e449a5d7f5c..250ea4efb7cb 100644
> |--- a/include/linux/firmware/qcom/qcom_scm.h
> |+++ b/include/linux/firmware/qcom/qcom_scm.h
> --------------------------
> 
> What tree is this patch made against?
> 

Sorry about that, I missed the previous changes in qcom_q6v5_pas in the
remoteproc tree. Elliot said he based it on linux-next, so I expect that
it will merge fine on top of -rc1, once that arrives.

Regards,
Bjorn

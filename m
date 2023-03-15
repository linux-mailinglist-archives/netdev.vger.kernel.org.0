Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6AB6BA632
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 05:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjCOE2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 00:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCOE2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 00:28:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA8B1DBA0;
        Tue, 14 Mar 2023 21:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E446461AE3;
        Wed, 15 Mar 2023 04:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC318C433D2;
        Wed, 15 Mar 2023 04:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678854486;
        bh=LAK7Ux218jJKDKVTmRf0R9iRAT4prcpZ1FxGOQoWDwg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Meg8cAsSQxJ7QxAuSZLPP3N2IuvTug41TVw+4NUkBgdNygxnFtsRmCtn/OOC6i1AA
         tENroIg/6Yu2qFS7vMD2C7KdJMIUajdU65LKHg1rZNYqJVyf12remllOOELwcqkWwM
         edNvhYYOcqd9SpbyhnoxGx2zG8UUj7Jiy0mqO640=
Date:   Wed, 15 Mar 2023 05:28:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bjorn Andersson <andersson@kernel.org>
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
Message-ID: <ZBFJU3Lp4+/EgSr5@kroah.com>
References: <20230213181832.3489174-1-quic_eberman@quicinc.com>
 <20230213214417.mtcpeultvynyls6s@ripper>
 <Y+tNRPf0PGdShf5l@kroah.com>
 <20230214172325.lplxgbprhj3bzvr3@ripper>
 <bdda82f7-933d-443b-614a-6befad2899b5@quicinc.com>
 <2ae96b75-82f1-165a-e56d-7446c90bb7af@quicinc.com>
 <20230315041119.fp7npwa5bia5hck3@ripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315041119.fp7npwa5bia5hck3@ripper>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 09:11:19PM -0700, Bjorn Andersson wrote:
> On Fri, Mar 03, 2023 at 01:09:08PM -0800, Elliot Berman wrote:
> > 
> > 
> > On 2/14/2023 10:52 AM, Elliot Berman wrote:
> > > 
> > > 
> > > On 2/14/2023 9:23 AM, Bjorn Andersson wrote:
> > > > On Tue, Feb 14, 2023 at 09:58:44AM +0100, Greg Kroah-Hartman wrote:
> > > > > On Mon, Feb 13, 2023 at 01:44:17PM -0800, Bjorn Andersson wrote:
> > > > > > On Mon, Feb 13, 2023 at 10:18:29AM -0800, Elliot Berman wrote:
> > > > > > > The maximum VMID for assign_mem is 63. Use a u64 to represent this
> > > > > > > bitmap instead of architecture-dependent "unsigned int"
> > > > > > > which varies in
> > > > > > > size on 32-bit and 64-bit platforms.
> > > > > > > 
> > > > > > > Acked-by: Kalle Valo <kvalo@kernel.org> (ath10k)
> > > > > > > Tested-by: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>
> > > > > > > Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> > > > > > 
> > > > > > Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> > > > > > 
> > > > > > @Greg, would you mind taking this through your tree for v6.3, you
> > > > > > already have a related change in fastrpc.c in your tree...
> > > > > 
> > > > > I tried, but it doesn't apply to my char-misc tree at all:
> > > > > 
> > > > > checking file drivers/firmware/qcom_scm.c
> > > > > Hunk #1 succeeded at 898 (offset -7 lines).
> > > > > Hunk #2 succeeded at 915 (offset -7 lines).
> > > > > Hunk #3 succeeded at 930 (offset -7 lines).
> > > > > checking file drivers/misc/fastrpc.c
> > > > > checking file drivers/net/wireless/ath/ath10k/qmi.c
> > > > > checking file drivers/remoteproc/qcom_q6v5_mss.c
> > > > > Hunk #1 succeeded at 227 (offset -8 lines).
> > > > > Hunk #2 succeeded at 404 (offset -10 lines).
> > > > > Hunk #3 succeeded at 939 with fuzz 1 (offset -28 lines).
> > > > > checking file drivers/remoteproc/qcom_q6v5_pas.c
> > > > > Hunk #1 FAILED at 94.
> > > > > 1 out of 1 hunk FAILED
> > > > > checking file drivers/soc/qcom/rmtfs_mem.c
> > > > > Hunk #1 succeeded at 30 (offset -1 lines).
> > > > > can't find file to patch at input line 167
> > > > > Perhaps you used the wrong -p or --strip option?
> > > > > The text leading up to this was:
> > > > > --------------------------
> > > > > |diff --git a/include/linux/firmware/qcom/qcom_scm.h
> > > > > b/include/linux/firmware/qcom/qcom_scm.h
> > > > > |index 1e449a5d7f5c..250ea4efb7cb 100644
> > > > > |--- a/include/linux/firmware/qcom/qcom_scm.h
> > > > > |+++ b/include/linux/firmware/qcom/qcom_scm.h
> > > > > --------------------------
> > > > > 
> > > > > What tree is this patch made against?
> > > > > 
> > > > 
> > > > Sorry about that, I missed the previous changes in qcom_q6v5_pas in the
> > > > remoteproc tree. Elliot said he based it on linux-next, so I expect that
> > > > it will merge fine on top of -rc1, once that arrives.
> > > > 
> > > 
> > > Yes, this patch applies on next-20230213. I guess there are enough
> > > changes were coming from QCOM side (via Bjorn's qcom tree) as well as
> > > the fastrpc change (via Greg's char-misc tree).
> > > 
> > > Let me know if I should do anything once -rc1 arrives. Happy to post
> > > version on the -rc1 if it helps.
> > > 
> > 
> > The patch now applies on tip of Linus's tree and on char-misc.
> 
> Greg, I have a couple more patches in the scm driver in my inbox. Would
> you be okay with me pulling this through the Qualcomm tree for v6.4?

Please do!

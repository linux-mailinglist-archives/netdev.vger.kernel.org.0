Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617FC308E53
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhA2UV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbhA2UVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:21:04 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08E1C0613D6
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:23 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id x21so10621557iog.10
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nhvF9PGHPykZ//tfBqMwf6Wd6smJWeypfZ3nnpPqJhQ=;
        b=fY48G4XUV5nA1Y+/YfKCAmxGTbIzY1eBq12gOKgmMX/TRRTlJOCPTEJP7mxrHXjMcC
         1g7mLeHtbLVN+YfBn2toqKqmuaU6gJ2jHMBhA+x98K7IZEQ24rdSywuQHXJMklO8jksr
         SCWzTKUOZXBSe2NRNakaEnaCoT8GHraA09/WsU1LZiiN3c2ThRGBWNxEdb2pWDDlkVHS
         o+Yeq8nY3KfR0/uNGHuWjPqrS2cZt+0LWTPPMKXDzlKS8AEI0LdI5TAes/dzccS+Jfgu
         /EppfHBb16FgcebKuQslOEZkzaJ4acp5sYygRhvkq9/MR5gxrDjbPfDYbre8aXH/1xYo
         HS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nhvF9PGHPykZ//tfBqMwf6Wd6smJWeypfZ3nnpPqJhQ=;
        b=d/RFRbIJqoIkJEVgVOhcvgKCU34hzhGvFQPbxUEexvpxCmMXJStUn5taVcc+vZeGni
         N8kk7+CjnSIxa3a1iQRyhSHNEsS4bWV/e70BNTQRP/RJpKxfvUpThoo6LTVRWx3eXtTx
         sdYBK/ucwDW+bjDW2xpJS6d3YMX/phzBI5U2O1WLoD1iWuw4qi+8JDQHEWuF66vAQ7G+
         lFedyMO6jHc3/xugL/SnECw4i2hPfn7q2KHM3iMuBxIN1cTSHCuZ7BtidGuLo70b4PhM
         T80qTmSGSiAC9h83Xd6d7bxyAy1eqj2+PzYaHN7qBSS6R5Uwmy0peGB8dljXRNQ4R3GW
         K6AA==
X-Gm-Message-State: AOAM531yFuch7Ds+ka6pAJA0h7tpjkhfjadHrBJl6grQEosvEbzwNU0t
        uabGpFgrk6AgA7gHdbFT8ObrOQ==
X-Google-Smtp-Source: ABdhPJzR5J6clkSLXEEUxoyqtq+nvIyEMtlFthb1yRWt35BJi+/1J56LUugLYWAVBRAg6ZniitoWsw==
X-Received: by 2002:a02:3844:: with SMTP id v4mr5042759jae.1.1611951623187;
        Fri, 29 Jan 2021 12:20:23 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h23sm4645738ila.15.2021.01.29.12.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 12:20:22 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/9] net: ipa: don't disable NAPI in suspend
Date:   Fri, 29 Jan 2021 14:20:10 -0600
Message-Id: <20210129202019.2099259-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few weeks ago I suggested a change that added a flag to determine
whether NAPI should be re-enabled on a channel when we're done
polling.  That change was questioned, and upon further investigation
I realized the IPA suspend path was "doing it wrong."

Currently (for newer hardware) the IPA driver suspends channels by
issuing a STOP command.  Part of the stop processing includes a
"freeze" operation, which quiesces activity, disables the I/O
completion interrupt, and disables NAPI.  But disabling NAPI is
only meant to be done when shutting down the channel; there is
no need to disable it when a channel is being stopped for suspend.

This series reworks the way channels are stopped, with the end
result being that neither NAPI nor the I/O completion interrupt is
disabled when a channel is suspended.

The first patch fixes an error handling bug in the channel starting
path.  The second patch creates a helper function to encpasulate
retrying channel stop commands.  The third also creates helper
functions, but in doing so it makes channel stop and start handling
be consistent for both "regular" stop and suspend.

The fourth patch open-codes the freeze and thaw functions as a first
step toward reworking what they do (reordering and eliminating steps).

The fifth patch makes the I/O completion interrupt get disabled
*after* a channel is stopped.  This eliminates a small race in which
the interrupt condition could occur between disabling the interrupt
and stopping the channel.  Once stopped, the channel will generate
no more I/O completion interrupts.

The sixth and seventh patches arrange for the completion interrupt
to be disabled only stopping a channel "for good", not when
suspending.  (The sixth patch just makes a small step to facilitate
review; these two could be squashed together.)

The 8th patch ensures a TX request--if initiated just before
stopping the TX queue--is included when determining whether a
a channel is quiesced for stop or suspend.

And finally the last patch implements the ultimate objective,
disabling NAPI *only* when "really" stopping a channel (not for
suspend).  Instead of disabling NAPI, a call to napi_synchronize()
ensures everything's done before we suspend.

					-Alex

Alex Elder (9):
  net: ipa: don't thaw channel if error starting
  net: ipa: introduce gsi_channel_stop_retry()
  net: ipa: introduce __gsi_channel_start()
  net: ipa: kill gsi_channel_freeze() and gsi_channel_thaw()
  net: ipa: disable IEOB interrupt after channel stop
  net: ipa: move completion interrupt enable/disable
  net: ipa: don't disable IEOB interrupt during suspend
  net: ipa: expand last transaction check
  net: ipa: don't disable NAPI in suspend

 drivers/net/ipa/gsi.c | 137 ++++++++++++++++++++++++++----------------
 1 file changed, 85 insertions(+), 52 deletions(-)

-- 
2.27.0


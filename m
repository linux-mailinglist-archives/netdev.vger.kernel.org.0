Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547F52DB2E1
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731352AbgLORll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730153AbgLORlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:41:36 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFD8C06179C;
        Tue, 15 Dec 2020 09:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:Subject:From:References:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oIC0MdRQMt1oa/a8mDmQrf1Hq+zlAnsG9Tdqvyanr4k=; b=l2rI2/aBl2diPgAOke4UXX/XnZ
        54O/Vi01oGUaO7a5DLndyx7qnBunKZrSfGjQ1pnbGz+VDeIHErCd4MJlfAfIBvYv7eQ8YSqNAjJXT
        hXp5xwSODWfS/mi1nulLWX4UarKTDxjmxpbchhYUxvp/1TQ0+eq9i6uXtyIn7XErs0z8=;
Received: from p4ff13815.dip0.t-ipconnect.de ([79.241.56.21] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kpEJL-0006uH-JY; Tue, 15 Dec 2020 18:40:31 +0100
To:     Youghandhar Chintala <youghand@codeaurora.org>,
        johannes@sipsolutions.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        pillair@codeaurora.org
References: <20201215172352.5311-1-youghand@codeaurora.org>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
Message-ID: <f2089f3c-db96-87bc-d678-199b440c05be@nbd.name>
Date:   Tue, 15 Dec 2020 18:40:30 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201215172352.5311-1-youghand@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-12-15 18:23, Youghandhar Chintala wrote:
> Currently in case of target hardware restart, we just reconfig and
> re-enable the security keys and enable the network queues to start
> data traffic back from where it was interrupted.
> 
> Many ath10k wifi chipsets have sequence numbers for the data
> packets assigned by firmware and the mac sequence number will
> restart from zero after target hardware restart leading to mismatch
> in the sequence number expected by the remote peer vs the sequence
> number of the frame sent by the target firmware.
> 
> This mismatch in sequence number will cause out-of-order packets
> on the remote peer and all the frames sent by the device are dropped
> until we reach the sequence number which was sent before we restarted
> the target hardware
> 
> In order to fix this, we trigger a sta disconnect, for the targets
> which expose this corresponding wiphy flag, in case of target hw
> restart. After this there will be a fresh connection and thereby
> avoiding the dropping of frames by remote peer.
> 
> The right fix would be to pull the entire data path into the host
> which is not feasible or would need lots of complex changes and
> will still be inefficient.
How about simply tracking which tids have aggregation enabled and send
DELBA frames for those after the restart?
It would mean less disruption for affected stations and less ugly hacks
in the stack for unreliable hardware.

- Felix

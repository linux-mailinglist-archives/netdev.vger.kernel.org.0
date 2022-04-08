Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF404F9C5C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238467AbiDHSUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiDHSUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:20:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859E614927D;
        Fri,  8 Apr 2022 11:17:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF6ED621CB;
        Fri,  8 Apr 2022 18:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C54C385A5;
        Fri,  8 Apr 2022 18:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649441878;
        bh=2ktX+yf7nlWuKQl8q5/RMFvhZuO9VS2BLEbBsxrsXao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cxCkp7xhXkWweVSor0PqOXRuURnpf77+LmxH6H5tzI5ZSQ2VmzIXGKsgp3OBw80tp
         9A6vkZzbApQO/OadYgNxfLoyGrLUkyHHjq1kWnLDFsTLoV7pro9rU4WIzMME+8filX
         bDe3dRqlDa3QmTF6OBHEUgnPnsywG9OcpC6IFCSBRB3/O8opNg1q3jX+mtekehnedi
         /SzJhNqtpggJSDi1mvI44KNKzF9qA3ob2rerks3u+H81Fy1faRTCGVOZtGqoj16OIV
         8003FaMuVjUinj/1y0Mxm0R/q6NaIQFUabuZzkQCieHEfGgP2NXbhkXemdGnyHNA4i
         0y4VBUd+0MN3g==
Date:   Fri, 8 Apr 2022 11:17:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com,
        alexandr.lobakin@intel.com, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH bpf-next 00/10] xsk: stop softirq processing on full XSK
 Rx queue
Message-ID: <20220408111756.1339cb68@kernel.org>
In-Reply-To: <82a1e9c1-6039-7ead-e663-2b0298f31ada@nvidia.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
        <8a81791e-342e-be8b-fc96-312f30b44be6@nvidia.com>
        <Yk/7mkNi52hLKyr6@boxer>
        <82a1e9c1-6039-7ead-e663-2b0298f31ada@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Apr 2022 15:48:44 +0300 Maxim Mikityanskiy wrote:
> >> 4. A slow or malicious AF_XDP application may easily cause an overflow of
> >> the hardware receive ring. Your feature introduces a mechanism to pause the
> >> driver while the congestion is on the application side, but no symmetric
> >> mechanism to pause the application when the driver is close to an overflow.
> >> I don't know the behavior of Intel NICs on overflow, but in our NICs it's
> >> considered a critical error, that is followed by a recovery procedure, so
> >> it's not something that should happen under normal workloads.  
> > 
> > I'm not sure I follow on this one. Feature is about overflowing the XSK
> > receive ring, not the HW one, right?  
> 
> Right. So we have this pipeline of buffers:
> 
> NIC--> [HW RX ring] --NAPI--> [XSK RX ring] --app--> consumes packets
> 
> Currently, when the NIC puts stuff in HW RX ring, NAPI always runs and 
> drains it either to XSK RX ring or to /dev/null if XSK RX ring is full. 
> The driver fulfills its responsibility to prevent overflows of HW RX 
> ring. If the application doesn't consume quick enough, the frames will 
> be leaked, but it's only the application's issue, the driver stays 
> consistent.
> 
> After the feature, it's possible to pause NAPI from the userspace 
> application, effectively disrupting the driver's consistency. I don't 
> think an XSK application should have this power.

+1
cover letter refers to busy poll, but did that test enable prefer busy
poll w/ the timeout configured right? It seems like similar goal can 
be achieved with just that.

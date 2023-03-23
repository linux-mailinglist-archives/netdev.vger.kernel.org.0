Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286576C6D8C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbjCWQaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbjCWQ3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:29:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD2E244B4;
        Thu, 23 Mar 2023 09:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BB3A627EB;
        Thu, 23 Mar 2023 16:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45880C433D2;
        Thu, 23 Mar 2023 16:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679588987;
        bh=Kj1HPQiCSg2GmK1tupptqZKZGWrQm1+Tfd/vO4/pd0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OR+D0j7zZ5M2RtTuJk7gL3llbchJRxXzdvt3iNVnZFjUTTgoYHLmOcL8rJz18cBmq
         NWc/0wAITRvHysWZ0puJgGREE0ObHdDm5BpDHiIeR11XsJJwodkzey0feFearKW2gv
         7WPsZHx79uPWHaZ9xzLbEumrtCQGbjpviTHfYgak=
Date:   Thu, 23 Mar 2023 17:29:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] net: usb: lan78xx: Limit packet length to skb->len
Message-ID: <ZBx+eGTSjRM8fvsf@kroah.com>
References: <202303180031.EsiDo4qY-lkp@intel.com>
 <20230317173606.91426-1-szymon.heidrich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317173606.91426-1-szymon.heidrich@gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 06:36:06PM +0100, Szymon Heidrich wrote:
> Packet length retrieved from descriptor may be larger than
> the actual socket buffer length. In such case the cloned
> skb passed up the network stack will leak kernel memory contents.
> 
> Additionally prevent integer underflow when size is less than
> ETH_FCS_LEN.
> 
> Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>

the test robot did not report the fact that the packet length needed to
be limited :(


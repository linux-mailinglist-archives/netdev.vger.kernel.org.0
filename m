Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74847513685
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348078AbiD1OPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242833AbiD1OPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:15:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C368301E;
        Thu, 28 Apr 2022 07:12:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F3350CE2B11;
        Thu, 28 Apr 2022 14:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6005C385A9;
        Thu, 28 Apr 2022 14:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651155144;
        bh=XuDmkp5knNTMVg+Td52R3UVUppW3G1Q7ZS0+FjxLhf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p5rQoDJ+YNSGzlct4a4nlbPh9dLt2pW2D+CTDcIpO37b96/icQXKGc9x4nhk2NZTl
         mGdmMBOqSdNcmftgfMdJdIF/4qnFbEWDu6CLJF1KgSVmhiy1Rs7H3aoDCBaK09B5Os
         ENutk2UkwYs7glTKSjF+qHVwUGo+boSzz8fRQYpA=
Date:   Thu, 28 Apr 2022 16:12:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     Duoming Zhou <duoming@zju.edu.cn>, krzysztof.kozlowski@linaro.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        davem@davemloft.net, alexander.deucher@amd.com,
        akpm@linux-foundation.org, broonie@kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v4] nfc: ... device_is_registered() is data race-able
Message-ID: <YmqgxNkXVetmrtde@kroah.com>
References: <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
 <YmpEZQ7EnOIWlsy8@kroah.com>
 <2d7c9164.2b1f.1806f2a8ed9.Coremail.linma@zju.edu.cn>
 <YmpNZOaJ1+vWdccK@kroah.com>
 <15d09db2.2f76.1806f5c4187.Coremail.linma@zju.edu.cn>
 <YmpcUNf7O+OK6/Ax@kroah.com>
 <20220428060628.713479b2@kernel.org>
 <f51aa1.41ae.180705614b5.Coremail.linma@zju.edu.cn>
 <YmqYgu++0OuhfFxy@kroah.com>
 <6ad27014.42f6.1807072bb39.Coremail.linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ad27014.42f6.1807072bb39.Coremail.linma@zju.edu.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 09:53:28PM +0800, Lin Ma wrote:
> Hello there
> 
> > 
> > How do you physically remove a NFC device from a system?  What types of
> > busses are they on?  If non-removable one, then odds are there's not
> > going to be many races so this is a low-priority thing.  If they can be
> > on removable busses (USB, PCI, etc.), then that's a bigger thing.
> 
> Well, these are great questions we didn't even touch to yet.
> For the BT, HAMRADIO, and NFC/NCI code, we simply use pseudo-terminal + line
> discipline to emulate a malicious device from user-space (CAP_NET_ADMIN required).
> 
> We will then survey the actual physical bus for the IRL used NFC device.
> 
> > 
> > But again, the NFC bus code should handle all of this for the drivers,
> > there's nothing special about NFC that should warrant a special need for
> > this type of thing.
> > 
> 
> Agree, but in my opinion, every layer besides the bus code has to handle this race.
> 
> The cleanup routine is from
> "down" to "up" like ... -> TTY -> NFCMRVL -> NCI -> NFC core
> while the other routines, like netlink command is from "up" to "down"
> user space -> netlink -> NFC -> NCI -> NFCMRVL -> ...
> 
> Their directions are totally reversed hence only each layer of the stack perform good
> synchronization can the code be race free.
> 
> For example, this detaching event awake code in bus, the running task in higher layer
> is not aware of this. The cleanup of each layer has to make sure any running code won't
> cause use-after-free. 

That is what proper reference counting is supposed to be for.  Perhaps
you are running into a driver subsystem that is not doing that well, or
at all?

Try adding the needed references and the use-after-free should almost be
impossible to happen.

thanks,

greg k-h

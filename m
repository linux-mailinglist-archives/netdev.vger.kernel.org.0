Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5656A2533
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 00:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjBXXwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 18:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBXXwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 18:52:19 -0500
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Feb 2023 15:52:17 PST
Received: from smtp-outbound6.duck.com (smtp-outbound6.duck.com [20.67.221.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA69F6F41F
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 15:52:17 -0800 (PST)
MIME-Version: 1.0
Subject: Re: 4-port ASMedia/RealTek RTL8125 2.5Gbps NIC freezes whole system
References: <AF9C0500-2909-4FF4-8E4E-3BAD8FD8AA14.1@smtp-inbound1.duck.com>
 <92181e0e-3ca0-b19c-71f3-607fbfdc40a3@gmail.com>
 <00F8F608-C2C6-454E-8CA4-F963BC9D7005.1@smtp-inbound1.duck.com>
Content-Type: text/plain;
        charset=UTF-8;
        format=flowed
Content-Transfer-Encoding: 8bit
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Received: by smtp-inbound1.duck.com; Fri, 24 Feb 2023 18:52:15 -0500
Message-ID: <0EC01861-B6F5-40C9-AAD0-6B4ACC1EA13A.1@smtp-inbound1.duck.com>
Date:   Fri, 24 Feb 2023 18:52:15 -0500
From:   fk1xdcio@duck.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=duck.com; h=From:
 Date: Message-ID: Cc: To: Content-Transfer-Encoding: Content-Type:
 References: Subject: MIME-Version; q=dns/txt; s=postal-KpyQVw;
 t=1677282736; bh=lfP7iH5xGHDkZcz6GFe4UD6i/UIzLoop6GXR0XG7zks=;
 b=YEnLx1qAPheM3MjaX7vC77bBsTuD5nwL4G2H/V4NFE20NB0nrkgrwf2uU0D5gvXlXWyCPDn7Z
 DgNpS5QQw4efSzbz04J/x3kVMk6AuwvzPheGXyD/PmIKk5pZYsvC6MjffYNXcgSDZLp0mOMAzVZ
 ywnlfY15YtzPzl0VGfuB6wQ=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-02-24 15:21, Heiner Kallweit wrote:
> On 24.02.2023 15:37, fk1xdcio@duck.com wrote:
>> I'm having problems getting this 4-port 2.5Gbps NIC to be stable. I 
>> have tried on multiple different physical systems both with Xeon 
>> server and i7 workstation chipsets and it behaves the same way on 
>> everything. Testing with latest Arch Linux and kernels 6.1, 6.2, and 
>> 5.15. I'm using the kernel default r8169 driver.
...
>> "SSU-TECH" (generic/counterfeit?) 4-port 2.5Gbps PCIe x4 card
>>   ASMedia ASM1812 PCIe switch (driver: pcieport)
>>   RTL8125BG x4 (driver: r8169)
...
> The network driver shouldn't be able to freeze the system. You can test 
> whether vendor driver r8125 makes a difference.
> This should provide us with an idea whether the root cause is at a 
> lower level.

Thanks for the suggestion. The official RealTek r8125-9.011.00 driver 
won't build on new kernels but I tried with LTS kernel 5.15.94.

I tried using the various parameters available on the r8125 module, 
including full debug=16, but nothing changed.

Using the r8125 driver gives different errors. Error D3cold to D0 (used 
to be D3hot) and then additional new Ethernet errors:

3,1276,295280722,-;pcieport 0000:04:02.0: can't change power state from 
D3cold to D0 (config space inaccessible)
  SUBSYSTEM=pci
  DEVICE=+pci:0000:04:02.0
3,1277,295481184,-;pcieport 0000:04:00.0: can't change power state from 
D3cold to D0 (config space inaccessible)
  SUBSYSTEM=pci
  DEVICE=+pci:0000:04:00.0
3,1278,295982345,-;enp7s0: cmd = 0xff, should be 0x07 \x0a.
3,1279,296082571,-;enp7s0: pci link is down \x0a.
3,1280,296132687,-;enp8s0: cmd = 0xff, should be 0x07 \x0a.
3,1281,296232919,-;enp8s0: pci link is down \x0a.
3,1282,296303082,-;enp9s0: cmd = 0xff, should be 0x07 \x0a.
3,1283,296403314,-;enp9s0: pci link is down \x0a.
3,1284,296453431,-;enp10s0: cmd = 0xff, should be 0x07 \x0a.
3,1285,296553661,-;enp10s0: pci link is down \x0a.
3,1286,298147344,-;enp7s0: cmd = 0xff, should be 0x07 \x0a.
3,1287,298247572,-;enp7s0: pci link is down \x0a.
3,1288,298307717,-;enp8s0: cmd = 0xff, should be 0x07 \x0a.

I don't know what "cmd = 0xff" is referring to. Is this a command 
directly to the Ethernet chipset?

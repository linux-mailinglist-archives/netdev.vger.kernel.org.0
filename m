Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0AF68216A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 02:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjAaBcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 20:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjAaBcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 20:32:43 -0500
X-Greylist: delayed 473 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Jan 2023 17:32:38 PST
Received: from mail.rackland.de (mail.rackland.de [IPv6:2a00:1970:709::2212:1a9b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECACD30B05
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 17:32:38 -0800 (PST)
Received: from [192.168.164.190] (ip5f58f311.dynamic.kabel-deutschland.de [95.88.243.17])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by mail.rackland.de (Postfix) with ESMTPSA id BE6F46064B
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:24:43 +0100 (CET)
Message-ID: <7e80987a-4022-7940-53e8-4eec29af898c@danisch.de>
Date:   Tue, 31 Jan 2023 02:24:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
From:   Hadmut Danisch <hadmut@danisch.de>
Subject: macvlan configuration problem: bridge mode setting
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_05,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

using Ubuntu 22.04, Kernel 5.15.0-58-generic, LXD 5.10-b392610, iproute2 
5.15.0-1ubuntu2


I ran into the problem that a virtual LXD container with an macvlan 
network interface mapped to the hosts ethernet adapter works as expected 
with all other machines in the LAN, including getting an IP address 
assigned by the DHCP server. But it cannot be reached from the HOST 
machine itself.


My first guess was that LXD does not set the macvlan into bridge mode, 
but leaves it in the default private mode, which would explain the 
problem. But LXD's source code showed that it sets the mode to bridge 
and uses iproute2's  ip program to set the interface.

I therefore tried commands like

ip link add name blubb address 02:4e:a6:27:01:07 link enp4s0 type 
macvlan mode bridge

ip link add link enp4s0 name sugar type macvlan mode bridge

which succeed without error message. But ip link show reports

9: blubb@enp4s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN 
mode DEFAULT group default qlen 1000
     link/ether 02:4e:a6:27:01:07 brd ff:ff:ff:ff:ff:ff
10: sugar@enp4s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN 
mode DEFAULT group default qlen 1000
     link/ether 26:99:d1:52:ba:e0 brd ff:ff:ff:ff:ff:ff

in both cases "mode DEFAULT", where I would expect „bridge“. Same with 
the interface assigned to the LXD virtual container.


Shouldn't this show the mode used in the ip link add command?

How can I check whether an interface has been correctly set into 
macvlan/bridge mode, and why can't the HOST itself communicate with the 
guest?

The maintainer of iproute2 told me that this mailing list is the place 
to ask.


regards

Hadmut




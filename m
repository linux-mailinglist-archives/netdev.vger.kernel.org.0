Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE23646BE0
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiLHJ1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiLHJ1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:27:53 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9521DA42;
        Thu,  8 Dec 2022 01:27:50 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 1BC14448;
        Thu,  8 Dec 2022 10:27:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1670491669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2R1Bw6RSyNPWkO+Irjl7dtJBDdipXBznfHNFG4kiq4g=;
        b=N9pz6Hulf8OSnpbXqumzH6zy4v1Im2Kssmr8IE/azJYuVa8JgNBgykOllJPdSf9S5YxdqT
        uX+6Rx1sdJC7wPmi+SJLCpEDgIqP38XSprJ2jLQWrB821ldU2egvVKVuvkhMqkqsVxqHkC
        qFiffa+iIZCtq5WzWuod7qnh54lx5b6OcnRF9AHDOJ7EjSyqkL8mIMWVdVUNfzkWoO8lJc
        xKRhtsn8CeHVNDUXG8c9ocvIIfFYavCgtuN/wLMtp5TYH0snqYp5MsWIjeHDQCrBszKlHo
        9KSsMTA9nXU/RkafAkqOS6M0I+LNC1W3AbG5AWip4HdSZOIm80pXLDS82JTYRg==
MIME-Version: 1.0
Date:   Thu, 08 Dec 2022 10:27:48 +0100
From:   Michael Walle <michael@walle.cc>
To:     horatiu.vultur@microchip.com
Cc:     Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        daniel.machon@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, lars.povlsen@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, olteanv@gmail.com, pabeni@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
In-Reply-To: <20221208092511.4122746-1-michael@walle.cc>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
 <20221208092511.4122746-1-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-08 10:25, schrieb Michael Walle:
> Hi Horatiu,
> 
>> Currently lan966x, doesn't allow to run PTP over interfaces that are
>> part of the bridge. The reason is when the lan966x was receiving a
>> PTP frame (regardless if L2/IPv4/IPv6) the HW it would flood this
>> frame.
>> Now that it is possible to add VCAP rules to the HW, such to trap 
>> these
>> frames to the CPU, it is possible to run PTP also over interfaces that
>> are part of the bridge.
> 
> This gives me:
> 
> # /etc/init.d/S65ptp4l start
> Starting linuxptp daemon: OK
> [   44.136870] vcap_val_rule:1678: keyset was not updated: -22
> [   44.140196] vcap_val_rule:1678: keyset was not updated: -22
> #
> 
> # ptp4l -v
> 3.1.1
> # uname -a
> Linux buildroot 6.1.0-rc8-next-20221208+ #924 SMP Thu Dec  8 10:08:58
> CET 2022 armv7l GNU/Linux
> 
> I don't know whats going on, but I'm happy to help with debugging with 
> some
> guidance.

Oh, and linuxptp is running on eth0, no bridges are set up. linuxptp
is started with "/usr/sbin/ptp4l -f /etc/linuxptp.cfg"

# cat /etc/linuxptp.cfg
# LinuxPTP configuration file for synchronizing the system clock to
# a remote PTP master in slave-only mode.
#
# By default synchronize time in slave-only mode using UDP and hardware 
time
# stamps on eth0. If the difference to master is >1.0 second correct by
# stepping the clock instead of adjusting the frequency.
#
# If you change the configuration don't forget to update the phc2sys
# parameters accordingly in linuxptp-system-clock.service (systemd)
# or the linuxptp SysV init script.

[global]
slaveOnly		1
delay_mechanism		Auto
network_transport	UDPv4
time_stamping		hardware
step_threshold		1.0

[eth0]

-michael

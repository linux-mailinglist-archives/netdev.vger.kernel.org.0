Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7918222A99
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 20:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgGPSFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 14:05:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34918 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727844AbgGPSFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 14:05:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594922712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bid2o9xhItv8ji/omqfjaS5XC1iUfTcX7qDylksvkag=;
        b=ftQOUQs5M7bf5HDPv5kkva6f/FIHXxXCFVTCyA1WE07HGq6xBnIkt+zAP8I0edD+mGCrU4
        SeaxIlPXV2VZPIOChGK2vpU4b37SP+RmNUq3UXPkGM1hKNb/3Zy4o+rA7ntMHbj8H4VI/L
        vIukWfK+Scgb6gU5H5vXMZsgI13p9cI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-pKAFVRVJPHa_-99xo-LAlQ-1; Thu, 16 Jul 2020 14:05:08 -0400
X-MC-Unique: pKAFVRVJPHa_-99xo-LAlQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C72D88014D4;
        Thu, 16 Jul 2020 18:05:06 +0000 (UTC)
Received: from starship (unknown [10.35.206.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A29F761982;
        Thu, 16 Jul 2020 18:05:04 +0000 (UTC)
Message-ID: <616736b7d9433625a429bc37f0c5120115d02f44.camel@redhat.com>
Subject: Re: Commit 'Bluetooth: Consolidate encryption handling in
 hci_encrypt_cfm' broke my JBL TUNE500BT headphones
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luiz Augusto Von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Date:   Thu, 16 Jul 2020 21:05:03 +0300
In-Reply-To: <CABBYNZ+YOJQi9a=pU2cc9czH1VoL04SdaXfnDksakCCfxx-skA@mail.gmail.com>
References: <3635193ecd8c6034731387404825e998df2fd788.camel@redhat.com>
         <CABBYNZ+YOJQi9a=pU2cc9czH1VoL04SdaXfnDksakCCfxx-skA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-07-16 at 09:16 -0700, Luiz Augusto von Dentz wrote:
> Hi Maxim,
> 
> On Thu, Jul 16, 2020 at 1:29 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > Hi,
> > 
> > Few days ago I bisected a recent regression in the 5.8 kernel:
> > 
> > git bisect start
> > # good: [3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162] Linux 5.7
> > git bisect good 3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162
> > # bad: [dcde237b9b0eb1d19306e6f48c0a4e058907619f] Merge tag 'perf-tools-fixes-2020-07-07' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
> > git bisect bad dcde237b9b0eb1d19306e6f48c0a4e058907619f
> > # bad: [a0a4d17e02a80a74a63c7cbb7bc8cea2f0b7d8b1] Merge branch 'pcmcia-next' of git://git.kernel.org/pub/scm/linux/kernel/git/brodo/linux
> > git bisect bad a0a4d17e02a80a74a63c7cbb7bc8cea2f0b7d8b1
> > # good: [09587a09ada2ed7c39aedfa2681152b5ac5641ee] arm64: mm: use ARCH_HAS_DEBUG_WX instead of arch defined
> > git bisect good 09587a09ada2ed7c39aedfa2681152b5ac5641ee
> > # good: [3248044ecf9f91900be5678919966715f1fb8834] Merge tag 'wireless-drivers-next-2020-05-25' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
> > git bisect good 3248044ecf9f91900be5678919966715f1fb8834
> > # bad: [cb8e59cc87201af93dfbb6c3dccc8fcad72a09c2] Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> > git bisect bad cb8e59cc87201af93dfbb6c3dccc8fcad72a09c2
> > # bad: [b8215dce7dfd817ca38807f55165bf502146cd68] selftests/bpf, flow_dissector: Close TAP device FD after the test
> > git bisect bad b8215dce7dfd817ca38807f55165bf502146cd68
> > # good: [b8ded9de8db34dd209a3dece94cf54fc414e78f7] net/smc: pre-fetch send buffer outside of send_lock
> > git bisect good b8ded9de8db34dd209a3dece94cf54fc414e78f7
> > # good: [1079a34c56c535c3e27df8def0d3c5069d2de129] Merge tag 'mac80211-next-for-davem-2020-05-31' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
> > git bisect good 1079a34c56c535c3e27df8def0d3c5069d2de129
> > # bad: [f395b69f40f580491ef56f2395a98e3189baa53c] dpaa2-eth: Add PFC support through DCB ops
> > git bisect bad f395b69f40f580491ef56f2395a98e3189baa53c
> > # bad: [a74d19ba7c41b6c1e424ef4fb7d4600f43ff75e5] net: fec: disable correct clk in the err path of fec_enet_clk_enable
> > git bisect bad a74d19ba7c41b6c1e424ef4fb7d4600f43ff75e5
> > # bad: [dafe2078a75af1abe4780313ef8dd8491ba8598f] ipv4: nexthop: Fix deadcode issue by performing a proper NULL check
> > git bisect bad dafe2078a75af1abe4780313ef8dd8491ba8598f
> > # bad: [feac90d756c03b03b83fabe83571bd88ecc96b78] Bluetooth: hci_qca: Fix suspend/resume functionality failure
> > git bisect bad feac90d756c03b03b83fabe83571bd88ecc96b78
> > # good: [a228f7a410290d836f3a9f9b1ed5aef1aab25cc7] Bluetooth: hci_qca: Enable WBS support for wcn3991
> > git bisect good a228f7a410290d836f3a9f9b1ed5aef1aab25cc7
> > # bad: [755dfcbca83710fa967d0efa7c5bb601f871a747] Bluetooth: Fix assuming EIR flags can result in SSP authentication
> > git bisect bad 755dfcbca83710fa967d0efa7c5bb601f871a747
> > # bad: [3ca44c16b0dcc764b641ee4ac226909f5c421aa3] Bluetooth: Consolidate encryption handling in hci_encrypt_cfm
> > git bisect bad 3ca44c16b0dcc764b641ee4ac226909f5c421aa3
> > # first bad commit: [3ca44c16b0dcc764b641ee4ac226909f5c421aa3] Bluetooth: Consolidate encryption handling in hci_encrypt_cfm
> 
> We just merged a fix for that:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=339ddaa626995bc6218972ca241471f3717cc5f4

Perfect. I tested the fix and it works well.
Do you plan to send this for inclusion to 5.8 kernel?

Best regards,
	Maxim Levitsky


> 
> > The sympthoms are that I am unable to pair the headphones, and even if I use an older kernel
> > to pair them, and then switch to the new kernel, the connection is established only sometimes.
> > 
> > Without this commit, I can pair the headphones 100% of the time.
> > 
> > I am not familiar with bluetooth debugging but I am willing to provide
> > any logs, do tests and try patches.
> > 
> > I am running fedora 32 on the affected system which has built-in intel wireless/bluetooth card,
> > 
> > PCI (wifi) part:
> > 47:00.0 Network controller: Intel Corporation Wi-Fi 6 AX200 (rev 1a)
> > 
> > USB (bluetooth) parrt:
> > Bus 011 Device 004: ID 8087:0029 Intel Corp.
> > 
> > My .config attached (custom built kernel)
> > 
> > Best regards,
> >         Maxim Levitsky
> > 
> 
> 



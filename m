Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B435511FD7
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 18:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfEBQOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 12:14:22 -0400
Received: from rs07.intra2net.com ([85.214.138.66]:52326 "EHLO
        rs07.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfEBQOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 12:14:22 -0400
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id ACEC415001EA;
        Thu,  2 May 2019 18:14:19 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 7B3994C9;
        Thu,  2 May 2019 18:14:19 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.20,VDF=8.15.29.0)
X-Spam-Status: 
X-Spam-Level: 0
Received: from rocinante.m.i2n (rocinante.m.i2n [172.16.1.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: smtp-auth-user)
        by mail.m.i2n (Postfix) with ESMTPSA id CA9F8222;
        Thu,  2 May 2019 18:14:17 +0200 (CEST)
From:   Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
To:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Hyperv netvsc - regression for 32-PAE kernel
Date:   Thu, 02 May 2019 18:14:17 +0200
Message-ID: <6166175.oDc9uM0lzg@rocinante.m.i2n>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all.

I have a custom linux OS vm running kernel 3.14 (32b with or without PAE) in 
windows 2012 R2. The vm has one Network Adapter and is generation 1. With this 
setup everything runs fine.

The problem started when I tried to update to kernel 4.19. The Synthetic 
network adapter driver does not successfully loads during boot and then the 
machine gets stuck.

If I remove the Network Adapter and add a Legacy one instead, the system runs 
normally. However, this implies an unacceptable performance regression for my 
use case.

I manage to boot the vm with the Network Adapter by adding "hv_netvsc" to the 
blacklist, so I can inspect the system. Manually running "modprobe -v 
hv_netvsc" doesn't show any errors, just the "instmod" for ucs2_string and 
hv_netvsc, and then hangs forever. The "dmesg" output shows the following 
problems:

[  994.830251] hv_netvsc 0969e9e1-1392-4ed6-a230-d5db70c76a3c (unnamed 
net_device) (uninitialized): 0x0 (len 0)
[  994.830306] hv_netvsc 0969e9e1-1392-4ed6-a230-d5db70c76a3c (unnamed 
net_device) (uninitialized): unhandled rndis message (type 0 len 0)
[  994.830435] hv_netvsc 0969e9e1-1392-4ed6-a230-d5db70c76a3c (unnamed 
net_device) (uninitialized): 0x0 (len 0)
[  994.830440] hv_netvsc 0969e9e1-1392-4ed6-a230-d5db70c76a3c (unnamed 
net_device) (uninitialized): unhandled rndis message (type 0 len 0)


The Network Adapter was "Not connected" during these error messages, but when 
connected to a Virtual Switch the errors are the same, except doubled, so I 
would have four "unhandled rndis message".

I tested kernel 4.19 without PAE, the module is loaded without problems and 
those error messages never appear. 

I also tested other stable kernel versions, for example 4.14.114, and this one 
actually works fine with PAE. At this point, it looked like a bisect could 
help me to get to the offending changes and to understand the problem.

So I got to the following commit:

commit 6ba34171bcbd10321c6cf554e0c1144d170f9d1a
Author: Michael Kelley <mikelley@microsoft.com>
Date:   Thu Aug 2 03:08:24 2018 +0000

    Drivers: hv: vmbus: Remove use of slow_virt_to_phys()
    
    slow_virt_to_phys() is only implemented for arch/x86.
    Remove its use in arch independent Hyper-V drivers, and
    replace with test for vmalloc() address followed by
    appropriate v-to-p function. This follows the typical
    pattern of other drivers and avoids the need to implement
    slow_virt_to_phys() for Hyper-V on ARM64.
    
    Signed-off-by: Michael Kelley <mikelley@microsoft.com>
    Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


The catch is that slow_virt_to_phys has a special trick implemented in order 
to keep specifically 32-PAE kernel working, it is explained in a comment 
inside the function.

Reverting this commit makes the kernel 4.19 32-bit PAE work again. However I 
believe a better solution might exist.

Comments are very much appreciated.

Cheers!
Julie R.




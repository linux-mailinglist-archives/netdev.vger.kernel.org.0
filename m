Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7BC2B0493
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgKLL6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:58:06 -0500
Received: from smtp-o-3.desy.de ([131.169.56.156]:53589 "EHLO smtp-o-3.desy.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbgKLL6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 06:58:05 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2020 06:58:03 EST
Received: from smtp-buf-3.desy.de (smtp-buf-3.desy.de [IPv6:2001:638:700:1038::1:a6])
        by smtp-o-3.desy.de (Postfix) with ESMTP id 101E8605AF
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 12:52:19 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp-o-3.desy.de 101E8605AF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=desy.de; s=default;
        t=1605181939; bh=43y3Y53ssiHMHjx6vPCvKqbXwna9ag1nGRQzRu/sm7U=;
        h=To:From:Subject:Cc:Date:From;
        b=r/t1wH1TKAbhiXhVm7YBtrFMpbJO3ZTZ+AqjJ9DA7xKk5EFc4shXfrgTWYr45OkKg
         CIUxwc78ydx+/SyEOIJzUV5/axUHKx/DFopeIEFMWQg1jzCTGgArgXthtMW/uYOjK2
         93gI/UNa6pbL1l1IDek3iFH8HdvJtqvugjIZdkEA=
Received: from smtp-m-3.desy.de (smtp-m-3.desy.de [IPv6:2001:638:700:1038::1:83])
        by smtp-buf-3.desy.de (Postfix) with ESMTP id 0C29BA0586
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 12:52:19 +0100 (CET)
X-Virus-Scanned: amavisd-new at desy.de
Received: from [131.169.146.66] (lb-56-26.desy.de [131.169.56.26])
        by smtp-intra-2.desy.de (Postfix) with ESMTP id D7F821001A7;
        Thu, 12 Nov 2020 12:52:18 +0100 (CET)
To:     netdev@vger.kernel.org
From:   Vladimir Rybnikov <vladimir.rybnikov@desy.de>
Subject: Problems with multicast delivery to application layer after kernel
 4.4.0-128
Cc:     Vladimir Rybnikov <vladimir.rybnikov@desy.de>
Message-ID: <f1b698a6-fd3b-4860-62d1-91d3f39d6d45@desy.de>
Date:   Thu, 12 Nov 2020 12:52:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux kerenl-network experts,


I work at DESY (Hamburg, Germany), and is responsible for Data Acquisition (DAQ) from different accelerators and experiments.


Every DAQ collects data over the network. UDP multicast is used to transfer the data. Every data source has a multicast sender (~ 200 instances). A Dell PowerEdge R730xd server (DAQ server: 256 GB RAM, 40 Cores) is used for the data receiving. The DAQ server has several 10Gb network adapters in different sub-nets to receive multicast from the senders sitting in the corresponding sub-nets.

Every sender is pushing data via a UDP socket bound to a multicast address. The data sending takes place every 100ms (10Hz),

The size of data can vary from some bytes up to several MB.
The data is split into 32KB messages sent via the UDP socket.

A multi-threaded fast collector runs on the DAQ server to receive the data.


We have found and successfully used the values of the kernel parameters to minimize packet losses on all network stack layers till the kernel 4.4.0-128.


Since one year (after trying to switch to other kernels kernel 4.4.0-xxx [sorry I cannot say what xxx was, but after 128], 4.6 .. ) we have a problem that looks like losses on the application layer.


In my current test 2 network interfaces are used. The multicast input rate is ~ 140MB/s for each interface.



  I'm testing kernel 5.6.0-1032-oem.
Previously kernel 5.4.0-52-generic was tested but with the same results.

The signature is the following:
1) no Rx looses in adapters
2) no counting InErrors RcvbufErrors InCsumErrors in /proc/net/snmp
3) no counts in any column but 0 in /proc/net/softnet_stat

The losses show up in bursts from time to time.
4) dropwatch shows "xxx drops in at ip_defrag+171 ..."


Putting it in one line:n my current test 2 network interfaces are used. The multicast input rate is ~ 140MB/s for each interface.

Multicast packages are seen by the network adapters but the application layer from time to time doesn't get them  simultaneously from all senders.

Here are some sysctl parameters  currently used values, I'm aware of, that could
influence on the losses level.

net.core.optmem_max = 40960
net.core.rmem_default = 16777216
net.core.rmem_max = 67108864
net.core.wmem_default = 212992
net.core.wmem_max = 212992
net.ipv4.igmp_max_memberships = 512
net.ipv4.udp_mem = 262144    327680    393216
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 4096

net.core.netdev_budget = 100000
net.core.netdev_max_backlog = 100000
net.ipv4.ipfrag_high_thresh = 33554432
net.ipv4.ipfrag_low_thresh = 16777216

All other parameters are without changes as they come with the kernel distribution.

We plan to switch to Ubuntu 20.04 next year, and therefore kernel 5.4(6) is going to be used.


I hope that this problem is solvable on the kernel level.


Many thanks in advance and best regards,

Vladimir

-- 
>/*********************************************************************\
>* Dr. Vladimir Rybnikov      Phone : [49] (40) 8998 4846              *
>* FLA/MCS4                   Fax   : [49] (40) 8998 4448              *
>* Geb. 55a/35                e-mail: Vladimir.Rybnikov@desy.de        *
>*                            WWW   : http://www.desy.de/~rybnikov/    * 
>+                                                                     +
>* Notkestr.85, DESY                                                   *
>* D-22607 Hamburg, Germany                                            *
>\*********************************************************************/


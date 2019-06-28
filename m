Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A860C59C9A
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfF1NJi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 09:09:38 -0400
Received: from mail03.roosit.eu ([212.19.193.213]:40666 "EHLO mail03.roosit.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbfF1NJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 09:09:38 -0400
X-Greylist: delayed 1361 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jun 2019 09:09:38 EDT
Received: from sx.f1-outsourcing.eu (host-213.189.39.136.telnetsolutions.pl [213.189.39.136] (may be forged))
        by mail03.roosit.eu (8.14.7/8.14.7) with ESMTP id x5SCksto013602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:46:56 +0200
Received: from sx.f1-outsourcing.eu (localhost.localdomain [127.0.0.1])
        by sx.f1-outsourcing.eu (8.13.8/8.13.8) with ESMTP id x5SCks3H019121
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:46:54 +0200
Date:   Fri, 28 Jun 2019 14:46:54 +0200
From:   "Marc Roos" <M.Roos@f1-outsourcing.eu>
To:     netdev <netdev@vger.kernel.org>
Message-ID: <"H0000071001429ae.1561726014.sx.f1-outsourcing.eu*"@MHS>
Subject: macvtap vlan and tcp header overhead (and mtu size)
x-scalix-Hops: 1
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I hope this is the right place to ask. I have a host setup for libvirt 
kvm/qemu vms. And I wonder a bit about the overhead of the macvtap and 
how to configure the mtu's properly. To be able to communicate with the 
host, I have moved the ip address of the host from the adapter to a 
macvtap to allow host communication. 

I have the below setup on hosts. 

                                              
                                +---------+   
                                | macvtap0|   
                             +--|   ip    |   
                             |  | mtu1500 |   
                             |  +---------+   
                 +---------+ |  +---------+   
                 |eth0.v100| |  | macvtap1|   
              +--|  no ip  +-+--|   ip    |   
 +---------+  |  | mtu1500 |    | mtu1500 |   
 |   eth0  |  |  +---------+    +---------+   
 |         +--+                               
 | mtu9000 |  |  +---------+                  
 +---------+  |  |eth0.v101|                  
              +--|   ip    |                  
                 | mtu9000 |                  
                 +---------+                  

https://pastebin.com/9jJrMCTD



I can do a ping -M do -s 9000 between hosts via the vlan interface 
eth0.v101. That is as expected.

The ping -M do -s 1500 macvtap0 and another host or macvtap1 fails. The 
maximum size that does not fragment is 1472.
That is 28 bytes??? Where have they gone? I am only using macvtap, can 
this be the combination of the parent interface being a vlan and that 
macvtap is not properly handling this? Anyone experienced something 
similar? Or can explain where these 28 bytes go?










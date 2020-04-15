Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23551A943D
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 09:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408036AbgDOH2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 03:28:39 -0400
Received: from smtp.netregistry.net ([202.124.241.204]:46132 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403937AbgDOH20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 03:28:26 -0400
Received: from pa49-197-21-111.pa.qld.optusnet.com.au ([49.197.21.111]:23893 helo=localhost)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1jOcSo-0004aP-08; Wed, 15 Apr 2020 17:28:20 +1000
Date:   Wed, 15 Apr 2020 17:28:00 +1000
From:   Russell Strong <russell@strong.id.au>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: vxlan mac address generation
Message-ID: <20200415172800.50a3acc7@strong.id.au>
In-Reply-To: <20200414211206.40a324b4@hermes.lan>
References: <20200415100524.1ed7f9f9@strong.id.au>
        <20200414211206.40a324b4@hermes.lan>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Apr 2020 21:12:06 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Wed, 15 Apr 2020 10:05:24 +1000
> Russell Strong <russell@strong.id.au> wrote:
> 
> > Hi Stephen,
> > 
> > I've hit a problem with vxlan not communicating because mac
> > addresses being duplicated when I use the same IFNAME across
> > multiple virtual machines. The mac address appears to be some sort
> > of hash related to the IFNAME. Changing the name changes the mac
> > address.
> > 
> > Looking at vxlan_setup this should be random (eth_hw_addr_random)
> > but it is not.
> > 
> > Is there a bug here?
> > 
> > Regards,
> > Russell Strong  
> 
> I don't know what platform you are using but on x86-64 Debian 10.
> 
> # ip li add vxlan0 type vxlan id 1
> vxlan: destination port not specified
> Will use Linux kernel default (non-standard value)
> Use 'dstport 4789' to get the IANA assigned value
> Use 'dstport 0' to get default and quiet this message
> # ip li show dev vxlan0
> 8: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
> DEFAULT group default qlen 1000 link/ether 5a:09:e2:81:08:61 brd
> ff:ff:ff:ff:ff:ff # ip li del dev vxlan0
> # ip li add vxlan0 type vxlan id 1
> vxlan: destination port not specified
> Will use Linux kernel default (non-standard value)
> Use 'dstport 4789' to get the IANA assigned value
> Use 'dstport 0' to get default and quiet this message
> # ip li show dev vxlan0
> 9: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
> DEFAULT group default qlen 1000 link/ether 06:8d:c0:4a:73:90 brd
> ff:ff:ff:ff:ff:ff # ip li del dev vxlan0
> 
> 
> # ip li add vxlan0 type vxlan id 1
> vxlan: destination port not specified
> Will use Linux kernel default (non-standard value)
> Use 'dstport 4789' to get the IANA assigned value
> Use 'dstport 0' to get default and quiet this message
> # ip li show dev vxlan0
> 11: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
> DEFAULT group default qlen 1000 link/ether a2:2e:04:f6:85:73 brd
> ff:ff:ff:ff:ff:ff
> 

I tried debian ( 4.19.0-8-amd64 ) and got the same result as you.  I am
using Fedora 31 ( 5.5.15-200.fc31.x86_64 ).  I have discovered a
difference:

On fedora /sys/class/net/v0/addr_assign_type = 3
On debian /sys/class/net/v0/addr_assign_type = 1

The debian value is what I would expect (NET_ADDR_RANDOM).  I thought
addr_assign_type was controlled by the driver.  Do you think this could
be a Fedora bug, or perhaps something has changed between 4.19 and 5.5?


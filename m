Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F670586C1
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfF0QNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:13:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26049 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbfF0QNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 12:13:10 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B95863082A9C;
        Thu, 27 Jun 2019 16:12:59 +0000 (UTC)
Received: from ovpn-112-41.rdu2.redhat.com (ovpn-112-41.rdu2.redhat.com [10.10.112.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5B675D719;
        Thu, 27 Jun 2019 16:12:54 +0000 (UTC)
Message-ID: <e23b40bd692c63ee1e2c944459756dc05e751b0b.camel@redhat.com>
Subject: Re: [RFC] longer netdev names proposal
From:   Dan Williams <dcbw@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, mlxsw@mellanox.com
Date:   Thu, 27 Jun 2019 11:12:54 -0500
In-Reply-To: <20190627082922.289225f7@hermes.lan>
References: <20190627094327.GF2424@nanopsycho>
         <20190627082922.289225f7@hermes.lan>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 27 Jun 2019 16:13:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-06-27 at 08:29 -0700, Stephen Hemminger wrote:
> On Thu, 27 Jun 2019 11:43:27 +0200
> Jiri Pirko <jiri@resnulli.us> wrote:
> 
> > Hi all.
> > 
> > In the past, there was repeatedly discussed the IFNAMSIZ (16) limit
> > for
> > netdevice name length. Now when we have PF and VF representors
> > with port names like "pfXvfY", it became quite common to hit this
> > limit:
> > 0123456789012345
> > enp131s0f1npf0vf6
> > enp131s0f1npf0vf22
> > 
> > Since IFLA_NAME is just a string, I though it might be possible to
> > use
> > it to carry longer names as it is. However, the userspace tools,
> > like
> > iproute2, are doing checks before print out. So for example in
> > output of
> > "ip addr" when IFLA_NAME is longer than IFNAMSIZE, the netdevice is
> > completely avoided.
> > 
> > So here is a proposal that might work:
> > 1) Add a new attribute IFLA_NAME_EXT that could carry names longer
> > than
> >    IFNAMSIZE, say 64 bytes. The max size should be only defined in
> > kernel,
> >    user should be prepared for any string size.
> > 2) Add a file in sysfs that would indicate that NAME_EXT is
> > supported by
> >    the kernel.
> > 3) Udev is going to look for the sysfs indication file. In case
> > when
> >    kernel supports long names, it will do rename to longer name,
> > setting
> >    IFLA_NAME_EXT. If not, it does what it does now - fail.
> > 4) There are two cases that can happen during rename:
> >    A) The name is shorter than IFNAMSIZ
> >       -> both IFLA_NAME and IFLA_NAME_EXT would contain the same
> > string:  
> >          original IFLA_NAME     = eth0
> >          original IFLA_NAME_EXT = eth0
> >          renamed  IFLA_NAME     = enp5s0f1npf0vf1
> >          renamed  IFLA_NAME_EXT = enp5s0f1npf0vf1
> >    B) The name is longer tha IFNAMSIZ
> >       -> IFLA_NAME would contain the original one, IFLA_NAME_EXT
> > would   
> >          contain the new one:
> >          original IFLA_NAME     = eth0
> >          original IFLA_NAME_EXT = eth0
> >          renamed  IFLA_NAME     = eth0
> >          renamed  IFLA_NAME_EXT = enp131s0f1npf0vf22

It makes me a bit uncomfortable to allow IFLA_NAME and IFLA_NAME_EXT to
be completely different. That sounds like a big source of confusion and
debugging problems in production.

Dan

> > This would allow the old tools to work with "eth0" and the new
> > tools would work with "enp131s0f1npf0vf22". In sysfs, there would
> > be symlink from one name to another.
> >       
> > Also, there might be a warning added to kernel if someone works
> > with IFLA_NAME that the userspace tool should be upgraded.
> > 
> > Eventually, only IFLA_NAME_EXT is going to be used by everyone.
> > 
> > I'm aware there are other places where similar new attribute
> > would have to be introduced too (ip rule for example).
> > I'm not saying this is a simple work.
> > 
> > Question is what to do with the ioctl api (get ifindex etc). I
> > would
> > probably leave it as is and push tools to use rtnetlink instead.
> > 
> > Any ideas why this would not work? Any ideas how to solve this
> > differently?
> > 
> > Thanks!
> > 
> > Jiri
> >      
> 
> I looked into this in the past, but then rejected it because
> there are so many tools that use names, not just iproute2.
> Plus long names are very user unfriendly.


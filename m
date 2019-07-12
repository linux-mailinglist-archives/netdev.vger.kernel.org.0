Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77F02669E8
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 11:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfGLJ17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 05:27:59 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34159 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfGLJ16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 05:27:58 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so8614684edb.1
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 02:27:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=q19ZZblxcugDfPH8SrS48KI6D8M0WZtvypgARfH+JAc=;
        b=E35cdKLOhUx3sS8MhvHHVoa0sQ3a4sKhLQ0OqESBUVOYJnSVXR48YHLjJ7zrNCrAHG
         s7x7pCB82qtDW/SPSlAZID71GGzYjmRk4nLnDuZ7Hr/cmunnczXJpCSjU/8sg2fu95Kj
         /51uqHKITCOOkm/QjnDFFa+lETAwvlLwrm0gtJ0b5tC8KAUdtaH3SMtsshpHUnCGFKBN
         GQu5LJesnUJAtlQxkyfU/NRyvapozRVQMTXiTSkT9ilrOXwbjVGJ9+DnPGyCb/jtfkh4
         MwynAOyzvYhg1zo01TOG0VMy1XPrkW62LQLk835SDEUgm6mNEg/Nv5Erv+P0gSRcp15P
         pSOA==
X-Gm-Message-State: APjAAAXDMpAtB22+obnKIv7n1tOWO14AdYzwDIghabsLC4O5plpqJ8Mp
        41Eip6uMnt5zu4IzkqmzbjuuhVcq6ec=
X-Google-Smtp-Source: APXvYqyKtUQRFVrYWDZBuwvhM+3CgGoXXZk57ZsqI4WjmFj2s+AxJ8bnJd9T7HKykGV5Q0NzlToZlw==
X-Received: by 2002:a17:906:4e95:: with SMTP id v21mr7269234eju.105.1562923677099;
        Fri, 12 Jul 2019 02:27:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id s17sm1672941ejz.70.2019.07.12.02.27.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 02:27:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5F257181CE6; Fri, 12 Jul 2019 11:27:55 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Neil Horman <nhorman@tuxdriver.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, pablo@netfilter.org,
        jakub.kicinski@netronome.com, pieter.jansenvanvuuren@netronome.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
In-Reply-To: <20190711235354.GA30396@hmswarspite.think-freely.org>
References: <20190707075828.3315-1-idosch@idosch.org> <20190707.124541.451040901050013496.davem@davemloft.net> <20190711123909.GA10978@splinter> <20190711235354.GA30396@hmswarspite.think-freely.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 12 Jul 2019 11:27:55 +0200
Message-ID: <87r26vvbz8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> On Thu, Jul 11, 2019 at 03:39:09PM +0300, Ido Schimmel wrote:
>> On Sun, Jul 07, 2019 at 12:45:41PM -0700, David Miller wrote:
>> > From: Ido Schimmel <idosch@idosch.org>
>> > Date: Sun,  7 Jul 2019 10:58:17 +0300
>> > 
>> > > Users have several ways to debug the kernel and understand why a packet
>> > > was dropped. For example, using "drop monitor" and "perf". Both
>> > > utilities trace kfree_skb(), which is the function called when a packet
>> > > is freed as part of a failure. The information provided by these tools
>> > > is invaluable when trying to understand the cause of a packet loss.
>> > > 
>> > > In recent years, large portions of the kernel data path were offloaded
>> > > to capable devices. Today, it is possible to perform L2 and L3
>> > > forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
>> > > Different TC classifiers and actions are also offloaded to capable
>> > > devices, at both ingress and egress.
>> > > 
>> > > However, when the data path is offloaded it is not possible to achieve
>> > > the same level of introspection as tools such "perf" and "drop monitor"
>> > > become irrelevant.
>> > > 
>> > > This patchset aims to solve this by allowing users to monitor packets
>> > > that the underlying device decided to drop along with relevant metadata
>> > > such as the drop reason and ingress port.
>> > 
>> > We are now going to have 5 or so ways to capture packets passing through
>> > the system, this is nonsense.
>> > 
>> > AF_PACKET, kfree_skb drop monitor, perf, XDP perf events, and now this
>> > devlink thing.
>> > 
>> > This is insanity, too many ways to do the same thing and therefore the
>> > worst possible user experience.
>> > 
>> > Pick _ONE_ method to trap packets and forward normal kfree_skb events,
>> > XDP perf events, and these taps there too.
>> > 
>> > I mean really, think about it from the average user's perspective.  To
>> > see all drops/pkts I have to attach a kfree_skb tracepoint, and not just
>> > listen on devlink but configure a special tap thing beforehand and then
>> > if someone is using XDP I gotta setup another perf event buffer capture
>> > thing too.
>> 
>> Dave,
>> 
>> Before I start working on v2, I would like to get your feedback on the
>> high level plan. Also adding Neil who is the maintainer of drop_monitor
>> (and counterpart DropWatch tool [1]).
>> 
>> IIUC, the problem you point out is that users need to use different
>> tools to monitor packet drops based on where these drops occur
>> (SW/HW/XDP).
>> 
>> Therefore, my plan is to extend the existing drop_monitor netlink
>> channel to also cover HW drops. I will add a new message type and a new
>> multicast group for HW drops and encode in the message what is currently
>> encoded in the devlink events.
>> 
> A few things here:
> IIRC we don't announce individual hardware drops, drivers record them in
> internal structures, and they are retrieved on demand via ethtool calls, so you
> will either need to include some polling (probably not a very performant idea),
> or some sort of flagging mechanism to indicate that on the next message sent to
> user space you should go retrieve hw stats from a given interface.  I certainly
> wouldn't mind seeing this happen, but its more work than just adding a new
> netlink message.
>
> Also, regarding XDP drops, we wont see them if the xdp program is offloaded to
> hardware (you'll need your hw drop gathering mechanism for that), but for xdp
> programs run on the cpu, dropwatch should alrady catch those.  I.e. if the xdp
> program returns a DROP result for a packet being processed, the OS will call
> kfree_skb on its behalf, and dropwatch wil call that.

There is no skb by the time an XDP program runs, so this is not true. As
I mentioned upthread, there's a tracepoint that will get called if an
error occurs (or the program returns XDP_ABORTED), but in most cases,
XDP_DROP just means that the packet silently disappears...

-Toke

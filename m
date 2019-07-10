Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258C0645D9
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 13:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfGJLjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 07:39:33 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38706 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfGJLjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 07:39:33 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so1846713edo.5
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 04:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KMupzow0wqyRrcKm11eUVMLWfIiGausw9jq0Q/O8Zas=;
        b=POr8TELrxKzB1QPB6pYYtLIUq9EIbBj1rQmQFxhxgrAv6TqNGAPdC60Cb0Knv6CeAZ
         IinpqxI2T1CJ449Z+nnl8CxSFwO93OoIE4B3RqpnJpZgKyTz+6WRB9VbyIQTn82pXWbm
         AQ0TLnKcWTwZWbnQnqdQfXgNmywQ18v1/qvULCD7FO2T/DBDVh3QvSfZWR9ZoHyVXsJf
         uPhZ/WZiNasFi+nY59r55oQJqUig54p5SQxRiZjWdcCeFD+U7U+Jdw6+tPS2jTHb50aY
         foPhYZY1eKP/DhcUiliqDALo5tNs8ijChEOhEkH5wACpZKzTIG1vtomqUTMe8I69SgKj
         /zrQ==
X-Gm-Message-State: APjAAAXaIAN8cxCyx59nbLK6NLCDEMYG/7+4KPbup43d/M7/3tEazl1K
        YfutmJYKnVGXkaFfTmKkCTm6Pw==
X-Google-Smtp-Source: APXvYqwWY9yXwgxSsnaRNpaNIjJ6my4eC8L7DkyAeDg1rFVL2/LcfAAUb+RherBqEZ6wxRnkwj05RA==
X-Received: by 2002:a17:906:81cb:: with SMTP id e11mr25256028ejx.37.1562758771050;
        Wed, 10 Jul 2019 04:39:31 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id q19sm441568ejt.67.2019.07.10.04.39.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 04:39:30 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C7170181CE7; Wed, 10 Jul 2019 13:39:29 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, pablo@netfilter.org,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@mellanox.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
In-Reply-To: <20190710112011.GA552@splinter>
References: <20190707075828.3315-1-idosch@idosch.org> <20190707.124541.451040901050013496.davem@davemloft.net> <20190708131908.GA13672@splinter> <20190708155158.3f75b57c@cakuba.netronome.com> <20190709123844.GA27309@splinter> <20190709153430.5f0f5295@cakuba.netronome.com> <20190710112011.GA552@splinter>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 10 Jul 2019 13:39:29 +0200
Message-ID: <87bly2w232.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@idosch.org> writes:

> On Tue, Jul 09, 2019 at 03:34:30PM -0700, Jakub Kicinski wrote:
>> On Tue, 9 Jul 2019 15:38:44 +0300, Ido Schimmel wrote:
>> > On Mon, Jul 08, 2019 at 03:51:58PM -0700, Jakub Kicinski wrote:
>> > > On Mon, 8 Jul 2019 16:19:08 +0300, Ido Schimmel wrote:  
>> > > > On Sun, Jul 07, 2019 at 12:45:41PM -0700, David Miller wrote:  
>> > > > > From: Ido Schimmel <idosch@idosch.org>
>> > > > > Date: Sun,  7 Jul 2019 10:58:17 +0300
>> > > > >     
>> > > > > > Users have several ways to debug the kernel and understand why a packet
>> > > > > > was dropped. For example, using "drop monitor" and "perf". Both
>> > > > > > utilities trace kfree_skb(), which is the function called when a packet
>> > > > > > is freed as part of a failure. The information provided by these tools
>> > > > > > is invaluable when trying to understand the cause of a packet loss.
>> > > > > > 
>> > > > > > In recent years, large portions of the kernel data path were offloaded
>> > > > > > to capable devices. Today, it is possible to perform L2 and L3
>> > > > > > forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
>> > > > > > Different TC classifiers and actions are also offloaded to capable
>> > > > > > devices, at both ingress and egress.
>> > > > > > 
>> > > > > > However, when the data path is offloaded it is not possible to achieve
>> > > > > > the same level of introspection as tools such "perf" and "drop monitor"
>> > > > > > become irrelevant.
>> > > > > > 
>> > > > > > This patchset aims to solve this by allowing users to monitor packets
>> > > > > > that the underlying device decided to drop along with relevant metadata
>> > > > > > such as the drop reason and ingress port.    
>> > > > > 
>> > > > > We are now going to have 5 or so ways to capture packets passing through
>> > > > > the system, this is nonsense.
>> > > > > 
>> > > > > AF_PACKET, kfree_skb drop monitor, perf, XDP perf events, and now this
>> > > > > devlink thing.
>> > > > > 
>> > > > > This is insanity, too many ways to do the same thing and therefore the
>> > > > > worst possible user experience.
>> > > > > 
>> > > > > Pick _ONE_ method to trap packets and forward normal kfree_skb events,
>> > > > > XDP perf events, and these taps there too.
>> > > > > 
>> > > > > I mean really, think about it from the average user's perspective.  To
>> > > > > see all drops/pkts I have to attach a kfree_skb tracepoint, and not just
>> > > > > listen on devlink but configure a special tap thing beforehand and then
>> > > > > if someone is using XDP I gotta setup another perf event buffer capture
>> > > > > thing too.    
>> > > > 
>> > > > Let me try to explain again because I probably wasn't clear enough. The
>> > > > devlink-trap mechanism is not doing the same thing as other solutions.
>> > > > 
>> > > > The packets we are capturing in this patchset are packets that the
>> > > > kernel (the CPU) never saw up until now - they were silently dropped by
>> > > > the underlying device performing the packet forwarding instead of the
>> > > > CPU.  
>> > 
>> > Jakub,
>> > 
>> > It seems to me that most of the criticism is about consolidation of
>> > interfaces because you believe I'm doing something you can already do
>> > today, but this is not the case.
>> 
>> To be clear I'm not opposed to the patches, I'm just trying to
>> facilitate a discussion.
>
> Sure, sorry if it came out the wrong way. I appreciate your feedback and
> the time you have spent on this subject.
>
>> 
>> > Switch ASICs have dedicated traps for specific packets. Usually, these
>> > packets are control packets (e.g., ARP, BGP) which are required for the
>> > correct functioning of the control plane. You can see this in the SAI
>> > interface, which is an abstraction layer over vendors' SDKs:
>> > 
>> > https://github.com/opencomputeproject/SAI/blob/master/inc/saihostif.h#L157
>> > 
>> > We need to be able to configure the hardware policers of these traps and
>> > read their statistics to understand how many packets they dropped. We
>> > currently do not have a way to do any of that and we rely on hardcoded
>> > defaults in the driver which do not fit every use case (from
>> > experience):
>> > 
>> > https://elixir.bootlin.com/linux/v5.2/source/drivers/net/ethernet/mellanox/mlxsw/spectrum.c#L4103
>> > 
>> > We plan to extend devlink-trap mechanism to cover all these use cases. I
>> > hope you agree that this functionality belongs in devlink given it is a
>> > device-specific configuration and not a netdev-specific one.
>> 
>> No disagreement on providing knobs for traps.
>> 
>> > That being said, in its current form, this mechanism is focused on traps
>> > that correlate to packets the device decided to drop as this is very
>> > useful for debugging.
>> 
>> That'd be mixing two things - trap configuration and tracing exceptions
>> in one API. That's a little suboptimal but not too terrible, especially
>> if there is a higher level APIs users can default to.
>
> TBH, initially I was only focused on the drops, but then it occurred to
> me that this is a too narrow scope. These traps are only a subset of the
> complete list of traps we have and we have similar requirements for both
> (statistics, setting policers etc.). Therefore, I decided to design this
> interface in a more generic way, so that it could support the different
> use cases.
>
>> 
>> > Given that the entire configuration is done via devlink and that devlink
>> > stores all the information about these traps, it seems logical to also
>> > report these packets and their metadata to user space as devlink events.
>> > 
>> > If this is not desirable, we can try to call into drop_monitor from
>> > devlink and add a new command (e.g., NET_DM_CMD_HW_ALERT), which will
>> > encode all the information we currently have in DEVLINK_CMD_TRAP_REPORT.
>> > 
>> > IMO, this is less desirable, as instead of having one tool (devlink) to
>> > interact with this mechanism we will need two (devlink & dropwatch).
>> > 
>> > Below I tried to answer all your questions and refer to all the points
>> > you brought up.
>> > 
>> > > When you say silently dropped do you mean that mlxsw as of today
>> > > doesn't have any counters exposed for those events?  
>> > 
>> > Some of these packets are counted, but not all of them.
>> > 
>> > > If we wanted to consolidate this into something existing we can either
>> > >  (a) add similar traps in the kernel data path;
>> > >  (b) make these traps extension of statistics.
>> > > 
>> > > My knee jerk reaction to seeing the patches was that it adds a new
>> > > place where device statistics are reported.  
>> > 
>> > Not at all. This would be a step back. We can already count discards due
>> > to VLAN membership on ingress on a per-port basis. A software maintained
>> > global counter does not buy us anything.
>> > 
>> > By also getting the dropped packet - coupled with the drop reason and
>> > ingress port - you can understand exactly why and on which VLAN the
>> > packet was dropped. I wrote a Wireshark dissector for these netlink
>> > packets to make our life easier. You can see the details in my comment
>> > to the cover letter:
>> > 
>> > https://marc.info/?l=linux-netdev&m=156248736710238&w=2
>> > 
>> > In case you do not care about individual packets, but still want more
>> > fine-grained statistics for your monitoring application, you can use
>> > eBPF. For example, one thing we did is attaching a kprobe to
>> > devlink_trap_report() with an eBPF program that dissects the incoming
>> > skbs and maintains a counter per-{5 tuple, drop reason}. With
>> > ebpf_exporter you can export these statistics to Prometheus on which you
>> > can run queries and visualize the results with Grafana. This is
>> > especially useful for tail and early drops since it allows you to
>> > understand which flows contribute to most of the drops.
>> 
>> No question that the mechanism is useful.
>> 
>> > > Users who want to know why things are dropped will not get detailed
>> > > breakdown from ethtool -S which for better or worse is the one stop
>> > > shop for device stats today.  
>> > 
>> > I hope I managed to explain why counters are not enough, but I also want
>> > to point out that ethtool statistics are not properly documented and
>> > this hinders their effectiveness. I did my best to document the exposed
>> > traps in order to avoid the same fate:
>> > 
>> > https://patchwork.ozlabs.org/patch/1128585/
>> > 
>> > In addition, there are selftests to show how each trap can be triggered
>> > to reduce the ambiguity even further:
>> > 
>> > https://patchwork.ozlabs.org/patch/1128610/
>> > 
>> > And a note in the documentation to make sure future functionality is
>> > tested as well:
>> > 
>> > https://patchwork.ozlabs.org/patch/1128608/
>> > 
>> > > Having thought about it some more, however, I think that having a
>> > > forwarding "exception" object and hanging statistics off of it is a
>> > > better design, even if we need to deal with some duplication to get
>> > > there.
>> > > 
>> > > IOW having an way to "trap all packets which would increment a
>> > > statistic" (option (b) above) is probably a bad design.
>> > > 
>> > > As for (a) I wonder how many of those events have a corresponding event
>> > > in the kernel stack?  
>> > 
>> > Generic packet drops all have a corresponding kfree_skb() calls in the
>> > kernel, but that does not mean that every packet dropped by the hardware
>> > would also be dropped by the kernel if it were to be injected to its Rx
>> > path.
>> 
>> The notion that all SW events get captured by kfree_skb() would not be
>> correct.
>
> I meant that the generic drop reasons I'm exposing with this patchset
> all correspond to reasons for which the kernel would drop packets.
>
>> We have the kfree_skb(), and xdp_exception(), and drivers can
>> drop packets if various allocations fail.. the situation is already not
>> great.
>> 
>> I think that having a single useful place where users can look to see
>> all traffic exception events would go a long way. 
>
> I believe this was Dave's point as well. We have one tool to monitor
> kfree_skb() drops and with this patchset we will have another to monitor
> HW drops. As I mentioned in my previous reply, I will look into sending
> the events via drop_monitor by calling into it from devlink.
>
> I'm not involved with XDP (as you might have noticed), but I assume
> drop_monitor could be extended for this use case as well by doing
> register_trace_xdp_exception(). Then you could monitor SW, HW and XDP
> events using a single netlink channel, potentially split into different
> multicast groups to allow user space programs to receive only the events
> they care about.

Yes, having XDP hook into this would be good! This ties in nicely with
the need for better statistics for XDP (see
https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#consistency-for-statistics-with-xdp).

Unfortunately, it's not enough to just hook into the xdp_exception trace
point, as that is generally only triggered on XDP_ABORTED, not if the
XDP program just decides to drop the packet with XDP_DROP. So we may
need another mechanism to hook this if it's going to comprehensive; and
we'd probably want a way to do this that doesn't impose a performance
penalty when the drop monitor is not enabled...

-Toke

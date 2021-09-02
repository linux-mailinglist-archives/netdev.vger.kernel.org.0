Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B193FF2FA
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 20:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346845AbhIBSGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 14:06:46 -0400
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:51923 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229939AbhIBSGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 14:06:46 -0400
Received: from cust-b66e5d83 ([IPv6:fc0c:c157:b88d:62c6:5e3c:5f07:82d0:1b4])
        by smtp-cloud9.xs4all.net with ESMTPA
        id Lr5smlARDlQKhLr5tmLDjQ; Thu, 02 Sep 2021 20:05:46 +0200
Received: from localhost (localhost [127.0.0.1])
        by keetweej.vanheusden.com (Postfix) with ESMTP id BF7AA1638DA;
        Thu,  2 Sep 2021 20:05:44 +0200 (CEST)
Received: from keetweej.vanheusden.com ([127.0.0.1])
        by localhost (mauer.intranet.vanheusden.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id s60_-dbANKzI; Thu,  2 Sep 2021 20:05:43 +0200 (CEST)
Received: from belle.intranet.vanheusden.com (belle.intranet.vanheusden.com [192.168.64.100])
        by keetweej.vanheusden.com (Postfix) with ESMTP id A0D5A163967;
        Thu,  2 Sep 2021 19:48:45 +0200 (CEST)
Received: by belle.intranet.vanheusden.com (Postfix, from userid 1000)
        id 902E9162F75; Thu,  2 Sep 2021 19:48:45 +0200 (CEST)
Date:   Thu, 2 Sep 2021 19:48:45 +0200
From:   folkert <folkert@vanheusden.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org
Subject: Re: masquerading AFTER first packet
Message-ID: <20210902174845.GE3350910@belle.intranet.vanheusden.com>
References: <20210901204204.GB3350910@belle.intranet.vanheusden.com>
 <20210902162612.GA23554@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20210902162612.GA23554@breakpoint.cc>
Reply-By: Wed 01 Sep 2021 07:11:01 PM CEST
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Envelope: MS4xfJn1EUnyGv5Kot2RSLpNQlOicWl20ui/2kjXEAfRmxY7J12xHDk8sD7/zJhiTTrgHSgEuQKJLzd8FZ6d/YiAzlfeijx/LEhjv0+tEp1Lul7mDLLOJ0Ri
 9JbT35k5w4pkj6NUqcHvwiZlRfZTqTgWh0qpZ5Rmz+eFCw8XvfRAy+0Znvq2OcMjB88exNLWj5zIO20t96IYYMkgWT36lGqOkKVNA78BxpKdMoVChUgQ5mhn
 Wrdof9HnO21UGRrIECDLNw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> > I'm seeing something strange. I'm doing an snmpwalk on an snmp server of
> > mine (behing DNAT) , and after the first response it goes into a timeout.
> > I did a tcpdump and saw this:
> > 
> > 1630528031.843264 IP 185.243.112.54.38377 > 37.34.63.177.161: GetNextRequest(23)  .1.3.6.1
> > 1630528031.843924 IP 37.34.63.177.161 > 185.243.112.54.38377: GetResponse(34)  .1.3.6.1.2=0   <-- ok
> > 1630528031.846950 IP 185.243.112.54.38377 > 37.34.63.177.161: GetNextRequest(24)  .1.3.6.1.2
> > 1630528031.847415 IP 192.168.4.2.161 > 185.243.112.54.38377: GetResponse(35)  .1.3.6.1.2.1=0  <-- fail
> > 1630528032.847649 IP 185.243.112.54.38377 > 37.34.63.177.161: GetNextRequest(24)  .1.3.6.1.2
> > 1630528032.848081 IP 192.168.4.2.161 > 185.243.112.54.38377: GetResponse(35)  .1.3.6.1.2.1=0  <-- fail
> 
> Looks like a kernel bug, but you did not include kernel version.

I'm definately seeing this with 5.10.0-8-amd64 (debian bullseye on a
vps) and I may have seen it with 4.9.0-5 as well (same system).

> Please also show 'ethtool -k' for in and out interfaces.

Included as attachment.

> You might want to try and disable udp releated offload settings to see
> if that helps.

If offloading is the problem, wouldn't the first packet fail as well?

> e.g.
> c3df39ac9b0e3747bf8233ea9ce4ed5ceb3199d3,
> "udp: ipv4: manipulate network header of NATed UDP GRO fraglist"
> which fixed a bug where only first packet of GRO'd udp train would
> have nat applied, (was broken between 5.6 and 5.11)

Ok I tried "ethtool -K eth* gro off" but it made no difference.

> Other explanation is that conntrack thinks only first packet is valid,
> you can check this for example via
> 
> sysctl net.netfilter.nf_conntrack_acct=1
> 
> and then checking if 'conntrack -L' shows increasing packet/byte
> counters or is stuck at '1'.

root@vps001:~# while true ; do conntrack -L 2>&1 | grep port=161 ; sleep 1 ; done
udp      17 3 src=185.243.112.54 dst=37.34.63.177 sport=40873 dport=161 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=40873 [ASSURED] mark=0 use=1
udp      17 2 src=185.243.112.54 dst=37.34.63.177 sport=40873 dport=161 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=40873 [ASSURED] mark=0 use=1
udp      17 1 src=185.243.112.54 dst=37.34.63.177 sport=40873 dport=161 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=40873 [ASSURED] mark=0 use=1
udp      17 29 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=2 bytes=133 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
udp      17 0 src=185.243.112.54 dst=37.34.63.177 sport=40873 dport=161 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=40873 [ASSURED] mark=0 use=1
udp      17 29 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=3 bytes=200 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
udp      17 119 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=4 bytes=267 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
udp      17 119 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=5 bytes=334 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
udp      17 119 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=6 bytes=401 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
udp      17 119 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=7 bytes=468 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
udp      17 118 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=7 bytes=468 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
...

So yes, increating packet/byte counters.

> If the remaining packets are indeed invalid, try setting
> sysctl net.netfilter.nf_conntrack_log_invalid=17


[Thu Sep  2 19:40:54 2021] DNAT: IN=eth0 OUT= MAC=52:54:00:65:21:38:0c:86:10:b5:91:e0:08:00 SRC=185.243.112.54 DST=37.34.63.177 LEN=66 TOS=0x00 PREC=0x00 TTL=55 ID=1501 DF PROTO=UDP SPT=56523 DPT=161 LEN=46 
[Thu Sep  2 19:40:54 2021] FWD: IN=eth0 OUT=eth1 MAC=52:54:00:65:21:38:0c:86:10:b5:91:e0:08:00 SRC=185.243.112.54 DST=192.168.4.2 LEN=66 TOS=0x00 PREC=0x00 TTL=54 ID=1501 DF PROTO=UDP SPT=56523 DPT=161 LEN=46 
[Thu Sep  2 19:40:54 2021] FWD: IN=eth0 OUT=eth1 MAC=52:54:00:65:21:38:0c:86:10:b5:91:e0:08:00 SRC=185.243.112.54 DST=192.168.4.2 LEN=67 TOS=0x00 PREC=0x00 TTL=54 ID=1502 DF PROTO=UDP SPT=56523 DPT=161 LEN=47 
[Thu Sep  2 19:40:54 2021] nf_ct_proto_17: bad checksum IN= OUT= SRC=192.168.4.2 DST=185.243.112.54 LEN=82 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=161 DPT=56523 LEN=61 
[Thu Sep  2 19:40:55 2021] FWD: IN=eth0 OUT=eth1 MAC=52:54:00:65:21:38:0c:86:10:b5:91:e0:08:00 SRC=185.243.112.54 DST=192.168.4.2 LEN=67 TOS=0x00 PREC=0x00 TTL=54 ID=1637 DF PROTO=UDP SPT=56523 DPT=161 LEN=47 
[Thu Sep  2 19:40:55 2021] nf_ct_proto_17: bad checksum IN= OUT= SRC=192.168.4.2 DST=185.243.112.54 LEN=82 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=161 DPT=56523 LEN=61 
[Thu Sep  2 19:40:56 2021] FWD: IN=eth0 OUT=eth1 MAC=52:54:00:65:21:38:0c:86:10:b5:91:e0:08:00 SRC=185.243.112.54 DST=192.168.4.2 LEN=67 TOS=0x00 PREC=0x00 TTL=54 ID=1700 DF PROTO=UDP SPT=56523 DPT=161 LEN=47 
[Thu Sep  2 19:40:56 2021] nf_ct_proto_17: bad checksum IN= OUT= SRC=192.168.4.2 DST=185.243.112.54 LEN=82 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=161 DPT=56523 LEN=61 
[Thu Sep  2 19:40:57 2021] FWD: IN=eth0 OUT=eth1 MAC=52:54:00:65:21:38:0c:86:10:b5:91:e0:08:00 SRC=185.243.112.54 DST=192.168.4.2 LEN=67 TOS=0x00 PREC=0x00 TTL=54 ID=1859 DF PROTO=UDP SPT=56523 DPT=161 LEN=47 
[Thu Sep  2 19:40:57 2021] nf_ct_proto_17: bad checksum IN= OUT= SRC=192.168.4.2 DST=185.243.112.54 LEN=82 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=161 DPT=56523 LEN=61 
[Thu Sep  2 19:40:58 2021] FWD: IN=eth0 OUT=eth1 MAC=52:54:00:65:21:38:0c:86:10:b5:91:e0:08:00 SRC=185.243.112.54 DST=192.168.4.2 LEN=67 TOS=0x00 PREC=0x00 TTL=54 ID=1946 DF PROTO=UDP SPT=56523 DPT=161 LEN=47 
[Thu Sep  2 19:40:58 2021] nf_ct_proto_17: bad checksum IN= OUT= SRC=192.168.4.2 DST=185.243.112.54 LEN=82 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=161 DPT=56523 LEN=61 
[Thu Sep  2 19:40:59 2021] FWD: IN=eth0 OUT=eth1 MAC=52:54:00:65:21:38:0c:86:10:b5:91:e0:08:00 SRC=185.243.112.54 DST=192.168.4.2 LEN=67 TOS=0x00 PREC=0x00 TTL=54 ID=2131 DF PROTO=UDP SPT=56523 DPT=161 LEN=47 
[Thu Sep  2 19:40:59 2021] nf_ct_proto_17: bad checksum IN= OUT= SRC=192.168.4.2 DST=185.243.112.54 LEN=82 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=161 DPT=56523 LEN=61 

Those 'bad checksum's are interesting:

root@vps001:~# tcpdump -r sep02.pcap -vv | grep 'udp sum ok'
reading from file test.pcap, link-type EN10MB (Ethernet), snapshot length 1600
    185.243.112.54.56523 > 192.168.4.2.snmp: [udp sum ok]  { SNMPv1 { GetNextRequest(23) R=1216445187  .iso.org.dod.internet } } 
    192.168.4.2.snmp > 185.243.112.54.56523: [udp sum ok]  { SNMPv1 { GetResponse(34) R=1216445187  .iso.org.dod.internet.mgmt=0 } } 
    185.243.112.54.56523 > 192.168.4.2.snmp: [udp sum ok]  { SNMPv1 { GetNextRequest(24) R=1216445188  .iso.org.dod.internet.mgmt } } 
    192.168.4.2.snmp > 185.243.112.54.56523: [udp sum ok]  { SNMPv1 { GetResponse(35) R=1216445188  =0 } } 
    185.243.112.54.56523 > 192.168.4.2.snmp: [udp sum ok]  { SNMPv1 { GetNextRequest(24) R=1216445188  .iso.org.dod.internet.mgmt } } 
    192.168.4.2.snmp > 185.243.112.54.56523: [udp sum ok]  { SNMPv1 { GetResponse(35) R=1216445188  =0 } } 
    185.243.112.54.56523 > 192.168.4.2.snmp: [udp sum ok]  { SNMPv1 { GetNextRequest(24) R=1216445188  .iso.org.dod.internet.mgmt } } 
    192.168.4.2.snmp > 185.243.112.54.56523: [udp sum ok]  { SNMPv1 { GetResponse(35) R=1216445188  =0 } } 
    185.243.112.54.56523 > 192.168.4.2.snmp: [udp sum ok]  { SNMPv1 { GetNextRequest(24) R=1216445188  .iso.org.dod.internet.mgmt } } 
    192.168.4.2.snmp > 185.243.112.54.56523: [udp sum ok]  { SNMPv1 { GetResponse(35) R=1216445188  =0 } } 
    185.243.112.54.56523 > 192.168.4.2.snmp: [udp sum ok]  { SNMPv1 { GetNextRequest(24) R=1216445188  .iso.org.dod.internet.mgmt } } 
    192.168.4.2.snmp > 185.243.112.54.56523: [udp sum ok]  { SNMPv1 { GetResponse(35) R=1216445188  =0 } } 
    185.243.112.54.56523 > 192.168.4.2.snmp: [udp sum ok]  { SNMPv1 { GetNextRequest(24) R=1216445188  .iso.org.dod.internet.mgmt } } 
    192.168.4.2.snmp > 185.243.112.54.56523: [udp sum ok]  { SNMPv1 { GetResponse(35) R=1216445188  =0 } } 

As you see, tcpdump says they're fine.

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="eth0.txt"

Features for eth0:
rx-checksumming: on [fixed]
tx-checksumming: on
	tx-checksum-ipv4: off [fixed]
	tx-checksum-ip-generic: on
	tx-checksum-ipv6: off [fixed]
	tx-checksum-fcoe-crc: off [fixed]
	tx-checksum-sctp: off [fixed]
scatter-gather: on
	tx-scatter-gather: on
	tx-scatter-gather-fraglist: off [fixed]
tcp-segmentation-offload: on
	tx-tcp-segmentation: on
	tx-tcp-ecn-segmentation: on
	tx-tcp-mangleid-segmentation: off
	tx-tcp6-segmentation: on
generic-segmentation-offload: on
generic-receive-offload: on
large-receive-offload: off
rx-vlan-offload: off [fixed]
tx-vlan-offload: off [fixed]
ntuple-filters: off [fixed]
receive-hashing: off [fixed]
highdma: on [fixed]
rx-vlan-filter: on [fixed]
vlan-challenged: off [fixed]
tx-lockless: off [fixed]
netns-local: off [fixed]
tx-gso-robust: on [fixed]
tx-fcoe-segmentation: off [fixed]
tx-gre-segmentation: off [fixed]
tx-gre-csum-segmentation: off [fixed]
tx-ipxip4-segmentation: off [fixed]
tx-ipxip6-segmentation: off [fixed]
tx-udp_tnl-segmentation: off [fixed]
tx-udp_tnl-csum-segmentation: off [fixed]
tx-gso-partial: off [fixed]
tx-tunnel-remcsum-segmentation: off [fixed]
tx-sctp-segmentation: off [fixed]
tx-esp-segmentation: off [fixed]
tx-udp-segmentation: off [fixed]
tx-gso-list: off [fixed]
fcoe-mtu: off [fixed]
tx-nocache-copy: off
loopback: off [fixed]
rx-fcs: off [fixed]
rx-all: off [fixed]
tx-vlan-stag-hw-insert: off [fixed]
rx-vlan-stag-hw-parse: off [fixed]
rx-vlan-stag-filter: off [fixed]
l2-fwd-offload: off [fixed]
hw-tc-offload: off [fixed]
esp-hw-offload: off [fixed]
esp-tx-csum-hw-offload: off [fixed]
rx-udp_tunnel-port-offload: off [fixed]
tls-hw-tx-offload: off [fixed]
tls-hw-rx-offload: off [fixed]
rx-gro-hw: off [fixed]
tls-hw-record: off [fixed]
rx-gro-list: off
macsec-hw-offload: off [fixed]

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="eth1.txt"

Features for myip:
rx-checksumming: off [fixed]
tx-checksumming: off
	tx-checksum-ipv4: off [fixed]
	tx-checksum-ip-generic: off [requested on]
	tx-checksum-ipv6: off [fixed]
	tx-checksum-fcoe-crc: off [fixed]
	tx-checksum-sctp: off [fixed]
scatter-gather: on
	tx-scatter-gather: on
	tx-scatter-gather-fraglist: on
tcp-segmentation-offload: off
	tx-tcp-segmentation: off [requested on]
	tx-tcp-ecn-segmentation: off [requested on]
	tx-tcp-mangleid-segmentation: off
	tx-tcp6-segmentation: off [requested on]
generic-segmentation-offload: on
generic-receive-offload: on
large-receive-offload: off [fixed]
rx-vlan-offload: off [fixed]
tx-vlan-offload: on
ntuple-filters: off [fixed]
receive-hashing: off [fixed]
highdma: off [fixed]
rx-vlan-filter: off [fixed]
vlan-challenged: off [fixed]
tx-lockless: on [fixed]
netns-local: off [fixed]
tx-gso-robust: off [fixed]
tx-fcoe-segmentation: off [fixed]
tx-gre-segmentation: off [fixed]
tx-gre-csum-segmentation: off [fixed]
tx-ipxip4-segmentation: off [fixed]
tx-ipxip6-segmentation: off [fixed]
tx-udp_tnl-segmentation: off [fixed]
tx-udp_tnl-csum-segmentation: off [fixed]
tx-gso-partial: off [fixed]
tx-tunnel-remcsum-segmentation: off [fixed]
tx-sctp-segmentation: off [fixed]
tx-esp-segmentation: off [fixed]
tx-udp-segmentation: off [fixed]
tx-gso-list: off [fixed]
fcoe-mtu: off [fixed]
tx-nocache-copy: off
loopback: off [fixed]
rx-fcs: off [fixed]
rx-all: off [fixed]
tx-vlan-stag-hw-insert: on
rx-vlan-stag-hw-parse: off [fixed]
rx-vlan-stag-filter: off [fixed]
l2-fwd-offload: off [fixed]
hw-tc-offload: off [fixed]
esp-hw-offload: off [fixed]
esp-tx-csum-hw-offload: off [fixed]
rx-udp_tunnel-port-offload: off [fixed]
tls-hw-tx-offload: off [fixed]
tls-hw-rx-offload: off [fixed]
rx-gro-hw: off [fixed]
tls-hw-record: off [fixed]
rx-gro-list: off
macsec-hw-offload: off [fixed]

--OXfL5xGRrasGEqWY
Content-Type: application/vnd.tcpdump.pcap
Content-Disposition: attachment; filename="sep02.pcap"
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAEAGAAABAAAApwwxYZrWBgBQAAAAUAAAAFI0hBZmJv74y07vJggA
RQAAQgXdQAA2EU/6ufNwNsCoBALcywChAC7z7zAkAgEABAZwdWJsaWOhFwIESIF7AwIBAAIB
ADAJMAcGAysGAQUApwwxYY/YBgBeAAAAXgAAAP74y07vJlI0hBZmJggARQAAUAAAQABAEUvJ
wKgEArnzcDYAodzLADzA1TAyAgQAAAAABAZwdWJsaWOiIgIESIF7AwIEAAAAAAIEAAAAADAO
MAwGBCsGAQICBAAAAACnDDFhbeUGAFEAAABRAAAAUjSEFmYm/vjLTu8mCABFAABDBd5AADYR
T/i583A2wKgEAtzLAKEAL/HnMCUCAQAEBnB1YmxpY6EYAgRIgXsEAgEAAgEAMAowCAYEKwYB
AgUApwwxYRznBgBgAAAAYAAAAP74y07vJlI0hBZmJggARQAAUgAAQABAEUvHwKgEArnzcDYA
odzLAD29zzAzAgQAAAAABAZwdWJsaWOiIwIESIF7BAIEAAAAAAIEAAAAADAPMA0GBSsGAQIB
AgQAAAAAAKgMMWGd6gYAUQAAAFEAAABSNIQWZib++MtO7yYIAEUAAEMGZUAANhFPcbnzcDbA
qAQC3MsAoQAv8ecwJQIBAAQGcHVibGljoRgCBEiBewQCAQACAQAwCjAIBgQrBgECBQCoDDFh
S+wGAGAAAABgAAAA/vjLTu8mUjSEFmYmCABFAABSAABAAEARS8fAqAQCufNwNgCh3MsAPb3P
MDMCBAAAAAAEBnB1YmxpY6IjAgRIgXsEAgQAAAAAAgQAAAAAMA8wDQYFKwYBAgECBAAAAAAA
qQwxYZjuBgBRAAAAUQAAAFI0hBZmJv74y07vJggARQAAQwakQAA2EU8yufNwNsCoBALcywCh
AC/x5zAlAgEABAZwdWJsaWOhGAIESIF7BAIBAAIBADAKMAgGBCsGAQIFAKkMMWFX8AYAYAAA
AGAAAAD++MtO7yZSNIQWZiYIAEUAAFIAAEAAQBFLx8CoBAK583A2AKHcywA9vc8wMwIEAAAA
AAQGcHVibGljoiMCBEiBewQCBAAAAAACBAAAAAAwDzANBgUrBgECAQIEAAAAAACqDDFh6+8G
AFEAAABRAAAAUjSEFmYm/vjLTu8mCABFAABDB0NAADYRTpO583A2wKgEAtzLAKEAL/HnMCUC
AQAEBnB1YmxpY6EYAgRIgXsEAgEAAgEAMAowCAYEKwYBAgUAqgwxYaTxBgBgAAAAYAAAAP74
y07vJlI0hBZmJggARQAAUgAAQABAEUvHwKgEArnzcDYAodzLAD29zzAzAgQAAAAABAZwdWJs
aWOiIwIESIF7BAIEAAAAAAIEAAAAADAPMA0GBSsGAQIBAgQAAAAAAKsMMWHJ8wYAUQAAAFEA
AABSNIQWZib++MtO7yYIAEUAAEMHmkAANhFOPLnzcDbAqAQC3MsAoQAv8ecwJQIBAAQGcHVi
bGljoRgCBEiBewQCAQACAQAwCjAIBgQrBgECBQCrDDFhr/UGAGAAAABgAAAA/vjLTu8mUjSE
FmYmCABFAABSAABAAEARS8fAqAQCufNwNgCh3MsAPb3PMDMCBAAAAAAEBnB1YmxpY6IjAgRI
gXsEAgQAAAAAAgQAAAAAMA8wDQYFKwYBAgECBAAAAAAArAwxYSL2BgBRAAAAUQAAAFI0hBZm
Jv74y07vJggARQAAQwhTQAA2EU2DufNwNsCoBALcywChAC/x5zAlAgEABAZwdWJsaWOhGAIE
SIF7BAIBAAIBADAKMAgGBCsGAQIFAKwMMWGv9wYAYAAAAGAAAAD++MtO7yZSNIQWZiYIAEUA
AFIAAEAAQBFLx8CoBAK583A2AKHcywA9vc8wMwIEAAAAAAQGcHVibGljoiMCBEiBewQCBAAA
AAACBAAAAAAwDzANBgUrBgECAQIEAAAAAAA=

--OXfL5xGRrasGEqWY--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3456553D8BF
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 00:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241470AbiFDWhd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 4 Jun 2022 18:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241336AbiFDWhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 18:37:32 -0400
X-Greylist: delayed 85 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 04 Jun 2022 15:37:31 PDT
Received: from x61w.mirbsd.org (2001-4dd7-ffe-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de [IPv6:2001:4dd7:ffe:0:21f:3bff:fe0d:cbb1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4252ACA
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 15:37:29 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 0C036254A7; Sun,  5 Jun 2022 00:36:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 0414E2549B
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 00:36:02 +0200 (CEST)
Date:   Sun, 5 Jun 2022 00:36:01 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: get TCP/UDP ports from skb
Message-ID: <a8dd829-b78e-c357-e91a-5ffeaf2a1927@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_50,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

is there some kind of helper function to obtain the port numbers
from an skb if it’s TCP or UDP?

I know I can do…

switch (skb->protocol) {
case cpu_to_be16(ETH_P_IP):
	/* IPv4 */
	if (skb_network_header(skb) + sizeof(struct iphdr) >
	    skb_tail_pointer(skb))
		goto noaddress;

	// copy IP address from ip_hdr(skb)->saddr and daddr

	switch (ip_hdr(skb)->protocol) {
	case /* TCP */ 6:
		if (skb_transport_header(skb) + sizeof(struct tcphdr) >
		    skb_tail_pointer(skb))
			goto no_nexthdr;
		sport = ntohs(tcp_hdr(skb)->source);
		dport = ntohs(tcp_hdr(skb)->dest);
		break;
	case /* UDP */ 17:
		if (skb_transport_header(skb) + sizeof(struct udphdr) >
		    skb_tail_pointer(skb))
			goto no_nexthdr;
		sport = ntohs(udp_hdr(skb)->source);
		dport = ntohs(udp_hdr(skb)->dest);
		break;
	// default, no_nexthdr here
	}

	//…
	break;

case cpu_to_be16(ETH_P_IPV6):
	/* IPv6 */
	if (skb_network_header(skb) + sizeof(struct ipv6hdr) >
	    skb_tail_pointer(skb))
		goto noaddress;

	// copy IP address from ipv6_hdr(skb)->saddr.s6_addr and daddr

	nexthdr = ipv6_hdr(skb)->nexthdr;

	↑↑↑↑↑↑↑

But I’m lost-ish at this point: nexthdr can be an extension header,
and it’s seemingly not documented whether skb_transport_header(skb)
is the address of the extension header or the address of the OSI L4
protocol that follows, either.

Do I need to do manual packet parsing here?

Can I somehow use the “flow dissector” thing, which is already used
to hash the skb into an (fq_codel) flow, to obtain IP/port? (If it’s
not IPv4/IPv6, I just need to know that; if it’s IPv4/IPv6 but not
TCP or UDP, same.)

The code is run in dequeue and drop context of a patched fq_codel
qdisc, for monitoring purposes, using relayfs/debugfs, in case that
matters.

Thanks in advance,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************

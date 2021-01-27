Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3B3305B5A
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbhA0M2a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Jan 2021 07:28:30 -0500
Received: from mail.a-eberle.de ([213.95.140.213]:54296 "EHLO mail.a-eberle.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234451AbhA0MZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 07:25:52 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.a-eberle.de (Postfix) with ESMTP id AEEA93806DF
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 13:15:40 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aeberle-mx.softwerk.noris.de
Received: from mail.a-eberle.de ([127.0.0.1])
        by localhost (ebl-mx-02.a-eberle.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id E3z3ekvEowCy for <netdev@vger.kernel.org>;
        Wed, 27 Jan 2021 13:15:39 +0100 (CET)
Received: from gateway.a-eberle.de (unknown [178.15.155.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "sg310.eberle.local", Issuer "A. Eberle GmbH & Co. KG WebAdmin CA" (not verified))
        (Authenticated sender: postmaster@a-eberle.de)
        by mail.a-eberle.de (Postfix) with ESMTPSA
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 13:15:39 +0100 (CET)
Received: from exch-svr2013.eberle.local ([192.168.1.9]:60091 helo=webmail.a-eberle.de)
        by gateway.a-eberle.de with esmtps (TLSv1.2:AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <Marco.Wenzel@a-eberle.de>)
        id 1l4jjT-00043E-0u
        for netdev@vger.kernel.org; Wed, 27 Jan 2021 13:15:35 +0100
Received: from EXCH-SVR2013.eberle.local (192.168.1.9) by
 EXCH-SVR2013.eberle.local (192.168.1.9) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 27 Jan 2021 13:15:35 +0100
Received: from EXCH-SVR2013.eberle.local ([::1]) by EXCH-SVR2013.eberle.local
 ([::1]) with mapi id 15.00.1497.006; Wed, 27 Jan 2021 13:15:35 +0100
From:   "Wenzel, Marco" <Marco.Wenzel@a-eberle.de>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: HSR/PRP sequence counter issue with Cisco Redbox
Thread-Topic: HSR/PRP sequence counter issue with Cisco Redbox
Thread-Index: Adb0oMB5N/nh+lgRSvKGIOcbXjKnGA==
Date:   Wed, 27 Jan 2021 12:15:34 +0000
Message-ID: <69ec2fd1a9a048e8b3305a4bc36aad01@EXCH-SVR2013.eberle.local>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.242.2.55]
x-kse-serverinfo: EXCH-SVR2013.eberle.local, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 27.01.2021 08:13:00
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

we have figured out an issue with the current PRP driver when trying to communicate with Cisco IE 2000 industrial Ethernet switches in Redbox mode. The Cisco always resets the HSR/PRP sequence counter to "1" at low traffic (<= 1 frame in 400 ms). It can be reproduced by a simple ICMP echo request with 1 s interval between a Linux box running with PRP and a VDAN behind the Cisco Redbox. The Linux box then always receives frames with sequence counter "1" and drops them. The behavior is not configurable at the Cisco Redbox.

I fixed it by ignoring sequence counters with value "1" at the sequence counter check in hsr_register_frame_out ():

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 5c97de459905..630c238e81f0 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -411,7 +411,7 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
 int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
                           u16 sequence_nr)
 {
-       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]))
+       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]) && (sequence_nr != 1))
                return 1;

        node->seq_out[port->type] = sequence_nr;


Do you think this could be a solution? Should this patch be officially applied in order to avoid other users running into these communication issues?

Thanks
Marco Wenzel

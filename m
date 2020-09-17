Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CBA26DBD4
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 14:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgIQMkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 08:40:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbgIQMjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 08:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600346357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=S7TD+QBtQUFQ5S4QEx+7/eynDF8kS4E6Y348DzqACFw=;
        b=gYXPnUu6OaZOTsYuqmD5AABzftWLoFsdcb/79HQbKwKzqYJyu/CCzTosqpfttc9C6cor0x
        9CCBakn6Un8t9gpEgTAEhUdwcFwl2K7i/6H30LXuzOWg9T5aAXvZ2WUeJK5SDM2JhbI8gK
        N6OFKnNOnZR6+ZzJ9UpiB8oLVAkWcv8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-pZ4ItpK6MJ2sq5fcAZ_--g-1; Thu, 17 Sep 2020 08:39:13 -0400
X-MC-Unique: pZ4ItpK6MJ2sq5fcAZ_--g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E5BD109109D;
        Thu, 17 Sep 2020 12:39:01 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A941610F2;
        Thu, 17 Sep 2020 12:38:47 +0000 (UTC)
Date:   Thu, 17 Sep 2020 14:38:46 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>
Cc:     brouer@redhat.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maciej Zenczykowski <maze@google.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>
Subject: BPF redirect API design issue for BPF-prog MTU feedback?
Message-ID: <20200917143846.37ce43a0@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


As you likely know[1] I'm looking into moving the MTU check (for TC-BPF)
in __bpf_skb_max_len() when e.g. called by bpf_skb_adjust_room(),
because when redirecting packets to another netdev it is not correct to
limit the MTU based on the incoming netdev.

I was looking at doing the MTU check in bpf_redirect() helper, because
at this point we know the redirect to netdev, and returning an
indication/error that MTU was exceed, would allow the BPF-prog logic to
react, e.g. sending ICMP (instead of packet getting silently dropped).
BUT this is not possible because bpf_redirect(index, flags) helper
don't provide the packet context-object (so I cannot lookup the packet
length).

Seeking input:

Should/can we change the bpf_redirect API or create a new helper with
packet-context?

 Note: We have the same need for the packet context for XDP when
 redirecting the new multi-buffer packets, as not all destination netdev
 will support these new multi-buffer packets.

I can of-cause do the MTU checks on kernel-side in skb_do_redirect, but
then how do people debug this? as packet will basically be silently dropped.



(Looking at how does BPF-prog logic handle MTU today)

How do bpf_skb_adjust_room() report that the MTU was exceeded?
Unfortunately it uses a common return code -ENOTSUPP which used for
multiple cases (include MTU exceeded). Thus, the BPF-prog logic cannot
use this reliably to know if this is a MTU exceeded event. (Looked
BPF-prog code and they all simply exit with TC_ACT_SHOT for all error
codes, cloudflare have the most advanced handling with
metrics->errors_total_encap_adjust_failed++).


[1] https://lore.kernel.org/bpf/159921182827.1260200.9699352760916903781.stgit@firesoul/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


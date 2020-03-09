Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 210E317DB39
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCIIjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:39:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46748 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726217AbgCIIjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 04:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583743185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y27k9B0xIugnyoUhDQSY/7wZSNse5Mph632zdP/weW0=;
        b=HwdoHR6fx7PLAq4pd/wNRmZI4Kq1JdG9nW+71EXnVpayC37BinDCUghDFZ4enjvDzrfTr5
        b696FKtEwFD/9QcLtk7IuTtyRWCtAIPAHUis7nhVffmSYiWfPVYfEDlLg5jGMZyl+tme+n
        sltL8gqxD6TYxZOWafddhZNvQoGC628=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-hNdsKe99OGiSDw3pVrgGwA-1; Mon, 09 Mar 2020 04:39:42 -0400
X-MC-Unique: hNdsKe99OGiSDw3pVrgGwA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC86E107ACC9;
        Mon,  9 Mar 2020 08:39:39 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2DF510027AC;
        Mon,  9 Mar 2020 08:39:33 +0000 (UTC)
Date:   Mon, 9 Mar 2020 09:39:32 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf@vger.kernel.org, gamemann@gflclan.com, lrizzo@google.com,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@toke.dk>, brouer@redhat.com
Subject: Re: [bpf-next PATCH] xdp: accept that XDP headroom isn't always
 equal XDP_PACKET_HEADROOM
Message-ID: <20200309093932.2a738ab1@carbon>
In-Reply-To: <5e62750bd8c9f_17502acca07205b42a@john-XPS-13-9370.notmuch>
References: <158323601793.2048441.8715862429080864020.stgit@firesoul>
        <20200303184350.66uzruobalf3y76f@ast-mbp>
        <5e62750bd8c9f_17502acca07205b42a@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 06 Mar 2020 08:06:35 -0800
John Fastabend <john.fastabend@gmail.com> wrote:

> Alexei Starovoitov wrote:
> > On Tue, Mar 03, 2020 at 12:46:58PM +0100, Jesper Dangaard Brouer wrote:  
[...]
> > > 
> > > Still for generic-XDP if headroom is less, still expand headroom to
> > > XDP_PACKET_HEADROOM as this is the default in most XDP drivers.
> > > 
> > > Tested on ixgbe with xdp_rxq_info --skb-mode and --action XDP_DROP:
> > > - Before: 4,816,430 pps
> > > - After : 7,749,678 pps
> > > (Note that ixgbe in native mode XDP_DROP 14,704,539 pps)
> > >   
> 
> But why do we care about generic-XDP performance? Seems users should
> just use XDP proper on ixgbe and i40e its supported.
>
[...]
> 
> Or just let ixgbe/i40e be slow? I guess I'm missing some context?

The context originates from an email thread[1] on XDP-newbies list, that
had a production setup (anycast routing of gaming traffic[3]) that used
XDP and they used XDP-generic (actually without realizing it).  They
were using Intel igb driver (that don't have native-XDP), and changing
to e.g. ixgbe (or i40e) is challenging given it requires physical access
to the PoP (Points of Presence) and upgrading to a 10G port at the PoP
also have costs associated.

Why not simply use TC-BPF (cls_bpf) instead of XDP.  I've actually been
promoting that more people should use TC-BPF, and also in combination[2].
The reason it makes sense to stick with XDP here is to allow them to
deploy the same software on their PoP servers, regardless of which
NIC driver is available.

Performance wise, I will admit that I've explicitly chosen not to
optimize XDP-generic, and I've even seen it as a good thing that we
have this reallocation penalty.  Given the uniform software deployment
argument and my measurements in[1] I've changed my mind.  For the igb
driver I'm not motivated to implement XDP-native, because a newer Intel
CPU can handle wirespeed even-with the reallocations, but it is just
wasteful to do these reallocations.  "Allowing" these 1Gbit/s NICs to
work more optimally with XDP-generic, will allow us to ignore
converting these drivers to XDP-native, and as HW gets upgraded they
will transition seamlessly to XDP-native.


[1] https://www.spinics.net/lists/xdp-newbies/msg01548.html
[2] https://github.com/xdp-project/xdp-cpumap-tc
[3] https://gitlab.com/Dreae/compressor/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


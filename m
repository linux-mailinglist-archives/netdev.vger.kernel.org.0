Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DE6206F90
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388945AbgFXJAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:00:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53200 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388864AbgFXJAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:00:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592989251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aZwutrrttlEmgVa3CH/9q95j+dYWB/11Frzh475oMM4=;
        b=TVwYdmXpAkCu6Djcl4Raa0SxqK0bRUXKhq4bvv8x4xmAkr6nYh/9jERvRqM6QmKoYDXMgh
        lJ3mDdy1W5zgSWBIw4IqUYzBE6aywmt8uKW9AJYUh2B6v23mzeV7S9Dk/bJoEP0gWOqWPS
        M7ezq5N04Jui/50euG4oK0MBgfD9v3A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-tSRd8ggIO7-RUqoqmpVrMg-1; Wed, 24 Jun 2020 05:00:46 -0400
X-MC-Unique: tSRd8ggIO7-RUqoqmpVrMg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A6DB107ACCA;
        Wed, 24 Jun 2020 09:00:44 +0000 (UTC)
Received: from carbon (unknown [10.40.208.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 180A25EDE2;
        Wed, 24 Jun 2020 09:00:40 +0000 (UTC)
Date:   Wed, 24 Jun 2020 11:00:39 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next 8/9] samples/bpf: xdp_redirect_cpu: load a
 eBPF program on cpumap
Message-ID: <20200624110039.75d05bba@carbon>
In-Reply-To: <cba75456c04b1df529c20d5a94092fb1011c0628.1592947694.git.lorenzo@kernel.org>
References: <cover.1592947694.git.lorenzo@kernel.org>
        <cba75456c04b1df529c20d5a94092fb1011c0628.1592947694.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 23:39:33 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Extend xdp_redirect_cpu_{usr,kern}.c adding the possibility to load
> a XDP program on cpumap entries. The following options have been added:
> - mprog-name: cpumap entry program name
> - mprog-filename: cpumap entry program filename
> - redirect-device: output interface if the cpumap program performs a
>   XDP_REDIRECT to an egress interface
> - redirect-map: bpf map used to perform XDP_REDIRECT to an egress
>   interface
> - mprog-disable: disable loading XDP program on cpumap entries
> 
> Add xdp_pass, xdp_drop, xdp_redirect stats accounting
> 
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


Example command and output:

sudo ./xdp_redirect_cpu --dev i40e2 --qsize 64 --cpu 2 --prog xdp_cpu_map0 \
  --mprog-filename xdp1_kern.o   --mprog-name xdp1

Running XDP/eBPF prog_name:xdp_cpu_map0
XDP-cpumap      CPU:to  pps            drop-pps    extra-info
XDP-RX          4       17,904,077     0           0          
XDP-RX          total   17,904,077     0          
cpumap-enqueue    4:2   17,904,076     418,122     8.00       bulk-average
cpumap-enqueue  sum:2   17,904,076     418,122     8.00       bulk-average
cpumap_kthread  2       17,485,954     0           35,139     sched
cpumap_kthread  total   17,485,954     0           35,139     sched-sum
redirect_err    total   0              0          
xdp_exception   total   0              0          

2nd remote XDP/eBPF prog_name: xdp1
XDP-cpumap      CPU:to  xdp-pass       xdp-drop    xdp-redir
xdp-in-kthread  2       0              17,485,955  0         
xdp-in-kthread  total   0              17,485,955  0         



Another example, where RSS is deliberately setup to only hit CPU-0.

 $ sudo ./xdp_redirect_cpu --dev i40e2 --qsize 192 --cpu 2  --cpu 3 --cpu 4 \
    --prog xdp_cpu_map5_lb_hash_ip_pairs \
    --mprog-name xdp_redirect --redirect-device mlx5p1  --redirect-map tx_port

Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
XDP-cpumap      CPU:to  pps            drop-pps    extra-info
XDP-RX          0       10,603,984     0           0          
XDP-RX          total   10,603,984     0          
cpumap-enqueue    0:2   3,539,815      0           6.88       bulk-average
cpumap-enqueue  sum:2   3,539,815      0           6.88       bulk-average
cpumap-enqueue    0:3   3,554,091      0           6.88       bulk-average
cpumap-enqueue  sum:3   3,554,091      0           6.88       bulk-average
cpumap-enqueue    0:4   3,510,076      84          6.87       bulk-average
cpumap-enqueue  sum:4   3,510,076      84          6.87       bulk-average
cpumap_kthread  2       3,539,817      0           91,310     sched
cpumap_kthread  3       3,554,101      0           93,604     sched
cpumap_kthread  4       3,509,991      0           92,893     sched
cpumap_kthread  total   10,603,910     0           277,809    sched-sum
redirect_err    total   0              0          
xdp_exception   total   0              0          

2nd remote XDP/eBPF prog_name: xdp_redirect
XDP-cpumap      CPU:to  xdp-pass       xdp-drop    xdp-redir
xdp-in-kthread  2       0              0           3,539,818 
xdp-in-kthread  3       0              0           3,554,101 
xdp-in-kthread  4       0              0           3,509,991 
xdp-in-kthread  total   0              0           10,603,910

More performance test examples can be found here:
 https://github.com/xdp-project/xdp-project/blob/master/areas/cpumap/cpumap04-map-xdp-prog.org

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E6C1ADB70
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 12:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbgDQKpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 06:45:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49406 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbgDQKpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 06:45:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAfTYp012408;
        Fri, 17 Apr 2020 10:44:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=TQ7i1aS5JprkOJb0WP9E3mfYaTgskW5/egV3j83ibvs=;
 b=RZJ0Qp5gG8btMgS8hIcTaJTJbbtggZkfcsBbJoO6I5tI7XrsFdPPVW+Ptv3HzWb3vRix
 L71T993OHV89oioCF7aJc/n6qzh1LJoytLpMeMt9qK8nabuggQn54eEcNVYJaf8HGAD3
 +cUYKGIQoRZnVRva4rJXEwKtHu3ykaS8gn5RuWMMfvDe2rCF58LDckLrIN4ktPphiNE6
 /uvnPGWglj5qVHlTXHe2eaSjHlOg7gfvw9N74qefSGgIfgx1sAm1N5Zmu3t6JdGr54Mt
 2sRTOtNLKDGnZVwAFwa7Ow6vuKJMCsPtTiqKIQ0vxycsmp/32BXJoTBiJaPESqc1sNIL Aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30emejp7jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:44:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAcIwH002498;
        Fri, 17 Apr 2020 10:42:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30dn9jkyn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:42:52 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HAgnsf019273;
        Fri, 17 Apr 2020 10:42:49 GMT
Received: from localhost.uk.oracle.com (/10.175.205.33)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 03:42:49 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC PATCH bpf-next 0/6] bpf, printk: add BTF-based type printing
Date:   Fri, 17 Apr 2020 11:42:34 +0100
Message-Id: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The printk family of functions support printing specific pointer types
using %p format specifiers (MAC addresses, IP addresses, etc).  For
full details see Documentation/core-api/printk-formats.rst.

This RFC patchset proposes introducing a "print typed pointer" format
specifier "%pT<type>"; the type specified is then looked up in the BPF
Type Format (BTF) information provided for vmlinux to support display.

There is already support in kernel/bpf/btf.c for "show" functionality;
the changes here generalize that support from seq-file specific
verifier display to the more generic case and add another specific
use case; snprintf()-style rendering of type information to a
provided buffer.  This support is then used to support printk
rendering of types, but the intent is to provide a function
that might be useful in other in-kernel scenarios; for example:

- ftrace could possibly utilize the function to support typed
  display of function arguments by cross-referencing BTF function
  information to derive the types of arguments
- oops/panic messaging could extend the information displayed to
  dig into data structures associated with failing functions

The above potential use cases hint at a potential reply to
a reasonable objection that such typed display should be
solved by tracing programs, where the in kernel tracing records
data and the userspace program prints it out.  While this
is certainly the recommended approach for most cases, I
believe having an in-kernel mechanism would be valuable
also.

The function the printk() family of functions rely on
could potentially be used directly for other use cases
like ftrace where we might have the BTF ids of the
pointers we wish to display; its signature is as follows:

int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
                           char *buf, int len, u64 flags);

So if ftrace say had the BTF ids of the types of arguments,
we see that the above would allow us to convert the
pointer data into displayable form.

To give a flavour for what the printed-out data looks like,
here we use pr_info() to display a struct sk_buff *.  Note
we specify the 'N' modifier to show type field names:

  struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);

  pr_info("%pTN<struct sk_buff>", skb);

...gives us:

{{{.next=00000000c7916e9c,.prev=00000000c7916e9c,{.dev=00000000c7916e9c|.dev_scratch=0}}|.rbnode={.__rb_parent_color=0,.rb_right=00000000c7916e9c,.rb_left=00000000c7916e9c}|.list={.next=00000000c7916e9c,.prev=00000000c7916e9c}},{.sk=00000000c7916e9c|.ip_defrag_offset=0},{.tstamp=0|.skb_mstamp_ns=0},.cb=['\0'],{{._skb_refdst=0,.destructor=00000000c7916e9c}|.tcp_tsorted_anchor={.next=00000000c7916e9c,.prev=00000000c7916e9c}},._nfct=0,.len=0,.data_len=0,.mac_len=0,.hdr_len=0,.queue_mapping=0,.__cloned_offset=[],.cloned=0x0,.nohdr=0x0,.fclone=0x0,.peeked=0x0,.head_frag=0x0,.pfmemalloc=0x0,.active_extensions=0,.headers_start=[],.__pkt_type_offset=[],.pkt_type=0x0,.ignore_df=0x0,.nf_trace=0x0,.ip_summed=0x0,.ooo_okay=0x0,.l4_hash=0x0,.sw_hash=0x0,.wifi_acked_valid=0x0,.wifi_acked=0x0,.no_fcs=0x0,.encapsulation=0x0,.encap_hdr_csum=0x0,.csum_valid=0x0,.__pkt_vlan_present_offset=[],.vlan_present=0x0,.csum_complete_sw=0x0,.csum_level=0x0,.csum_not_inet=0x0,.dst_pending_co

printk output is truncated at 1024 bytes.  For such cases, the compact
display mode (minus the field info 'N') may be used at the expense of
readability. "|" differentiates between different union members, but
aside from that the format is intended to minic a valid C initiailizer
for the given type.

The hope is that this functionality will be useful for debugging,
and possibly help facilitate the cases mentioned above in the future.

The patches are marked RFC for several reasons

- There's already an RFC patchset in flight dealing with BTF dumping;

https://www.spinics.net/lists/netdev/msg644412.html

  The reason I'm posting this is the approach is a bit different 
  and there may be ways of synthesizing the approaches.
- The mechanism of vmlinux BTF initialization is not fit for purpose
  in a printk() setting as I understand it (it uses mutex locking
  to prevent multiple initializations of the BTF info).  A simple
  approach to support printk might be to simply initialize the
  BTF vmlinux case early in boot; it only needs to happen once.
  Any suggestions here would be great.
- BTF-based rendering is more complex than other printk() format
  specifier-driven methods; that said, because of its generality it
  does provide significant value I think
- More tests are needed.

Alan Maguire (6):
  bpf: provide function to get vmlinux BTF information
  bpf: btf->resolved_[ids,sizes] should not be used for vmlinux BTF
  bpf: move to generic BTF show support, apply it to seq files/strings
  checkpatch: add new BTF pointer format specifier
  printk: add type-printing %pT<type> format specifier which uses BTF
  printk: extend test_printf to test %pT BTF-based format specifier

 Documentation/core-api/printk-formats.rst |   8 +
 include/linux/bpf.h                       |   2 +
 include/linux/btf.h                       |  35 ++-
 kernel/bpf/btf.c                          | 466 ++++++++++++++++++++++++------
 kernel/bpf/verifier.c                     |  18 +-
 lib/Kconfig                               |  16 +
 lib/test_printf.c                         | 118 ++++++++
 lib/vsprintf.c                            | 145 +++++++++-
 scripts/checkpatch.pl                     |   2 +-
 9 files changed, 704 insertions(+), 106 deletions(-)

-- 
1.8.3.1


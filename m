Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291981B9781
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 08:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD0GgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 02:36:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:16588 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgD0GgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 02:36:05 -0400
IronPort-SDR: +tEjFCGLqhGop3zX9xy1FtnIqSQBFDQFM7IYWBYRYWSAwjoZMvloWqXME5h4hpdteVFgFkiIcO
 EqdCkzsx8jtw==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2020 23:36:05 -0700
IronPort-SDR: Ut0YDav9MRnkvMws2fLFS8zg1C/k31aI3cWdZPvub+wsu6A0I2Cmux6GoEL0M6+HVmJwjauQwv
 3aPC/9DZ35tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,323,1583222400"; 
   d="gz'50?scan'50,208,50";a="431620579"
Received: from fyao2-mobl.ccr.corp.intel.com (HELO [10.255.30.76]) ([10.255.30.76])
  by orsmga005.jf.intel.com with ESMTP; 26 Apr 2020 23:36:02 -0700
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, ecree@solarflare.com,
        netdev@vger.kernel.org, yhs@fb.com
From:   Ma Xinjian <max.xinjian@intel.com>
Subject: Re: [bpf-next PATCH 03/10] bpf: verifer, adjust_scalar_min_max_vals
 to always call update_reg_bounds()
Message-ID: <072ad6df-9136-bfb9-e260-f6003e7d8777@intel.com>
Date:   Mon, 27 Apr 2020 14:35:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------9AF489699388492211C32EDE"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------9AF489699388492211C32EDE
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi, John.


During our test, we noticed this commit not only cause test_verifier error

"bpf: test_verifier, #70 error message updates for 32-bit right shift"

But also cause test_align error:

```

"Test   9: dubious pointer arithmetic ... Failed to find match 7: 
R5_w=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"

"Test  10: variable subtraction ... Failed to find match 12: 
R6=inv(id=0,smin_value=-1006,smax_value=1034,var_off=(0x2; 
0xfffffffffffffffc))"

```

clang/llvm version: 11.0.0


Whole error message please refer to  the attachment.

part of error info:

```

# Test   9: dubious pointer arithmetic ... Failed to find match 7: 
R5_w=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))
# func#0 @0
# 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
# 0: (61) r2 = *(u32 *)(r1 +76)
# 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 1: (61) r3 = *(u32 *)(r1 +80)
# 2: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) 
R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 2: (b7) r0 = 0
# 3: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) 
R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 3: (bf) r5 = r3
# 4: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) 
R3_w=pkt_end(id=0,off=0,imm=0) R5_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 4: (1f) r5 -= r2
# 5: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) 
R3_w=pkt_end(id=0,off=0,imm=0) R5_w=inv(id=0) R10=fp0
# 5: (67) r5 <<= 2
# 6: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) 
R3_w=pkt_end(id=0,off=0,imm=0) 
R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 
0xfffffffffffffffc)) R10=fp0
# 6: (07) r5 += 14
[snip]

# 15: (61) r4 = *(u32 *)(r6 +0)
# invalid access to packet, off=0 size=4, R6(id=1,off=0,r=0)
# R6 offset is outside of the packet
# processed 16 insns (limit 1000000) max_states_per_insn 0 total_states 
1 peak_states 1 mark_read 1
# FAIL
# Test  10: variable subtraction ... Failed to find match 12: 
R6=inv(id=0,smin_value=-1006,smax_value=1034,var_off=(0x2; 
0xfffffffffffffffc))
# func#0 @0
# 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
# 0: (61) r2 = *(u32 *)(r1 +76)
# 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
# 1: (61) r3 = *(u32 *)(r1 +80)
# 2: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) 
R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 2: (bf) r0 = r2
# 3: R0_w=pkt(id=0,off=0,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) 
R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 3: (07) r0 += 8
# 4: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) 
R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 4: (3d) if r3 >= r0 goto pc+1
#  R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) 
R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: R0_w=pkt(id=0,off=8,r=0,imm=0) R1=ctx(id=0,off=0,imm=0) 
R2_w=pkt(id=0,off=0,r=0,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 5: (95) exit
# 6: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) 
R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) R10=fp0
# 6: (71) r6 = *(u8 *)(r2 +0)
# 7: R0_w=pkt(id=0,off=8,r=8,imm=0) R1=ctx(id=0,off=0,imm=0) 
R2_w=pkt(id=0,off=0,r=8,imm=0) R3_w=pkt_end(id=0,off=0,imm=0) 
R6_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R10=fp0
# 7: (bf) r7 = r6
[snip]

```

---
Best Regards.
Ma Xinjian






--------------9AF489699388492211C32EDE
Content-Type: application/gzip;
 name="bpf_test_align_log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bpf_test_align_log.gz"

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
--------------9AF489699388492211C32EDE--

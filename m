Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521A81CF7AD
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgELOqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:46:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58588 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgELOqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:46:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CEh3Ck045852;
        Tue, 12 May 2020 14:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=vL6DNi8gvHCPAU6+yvj8mgnIo6NiiQw7071CCeFVoq4=;
 b=NEmAcht+axOasRHR25dGejixJ7LzucpmbKyBWyNwKKMbvsFle8QTj/Uxu8RdS2Ar7YW1
 zt6Y85fLxmDD1MYhcnjMDJi7HpnPxtxczMi1aWdscDmyKz/6a6OuoN4jzQskQBt43nrp
 +QzdTSmgWW0vCf7Y9EgknIwGWb19ZGXsOCNjuTxSZc4O8Ydx0XBU3Zha63tqkj2Wg/24
 OTirYzUpZRYU3xF+9LSOZ84nYh+MPjack/JcQqZ/dZoKMQQW2mI0RYM+Y7X5i1zUEAsa
 SV9qL+8vD5n2/ltgauSd0VE4lVYGs4x/3mK0HhoMEmS6veteOV4mBGhDd6eYTMCA6YQE DQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30x3mbue9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 14:46:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CEhjJ6034799;
        Tue, 12 May 2020 14:46:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30x63px5wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 14:46:31 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CEkUkD014089;
        Tue, 12 May 2020 14:46:30 GMT
Received: from dhcp-10-175-167-216.vpn.oracle.com (/10.175.167.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 07:46:29 -0700
Date:   Tue, 12 May 2020 15:46:27 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     bpf@vger.kernel.org
cc:     netdev@vger.kernel.org
Subject: bpf selftest execution issues
Message-ID: <alpine.LRH.2.21.2005121538120.22093@localhost>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=57
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=57 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running BPF tests I ran into some issues and couldn't get a clean
set of results on the bpf-next master branch. Just wanted to check if anyone 
else is seeing any of these failures.

1. Timeouts. When running "make run_tests" in tools/testing/selftests/bpf,
the kselftest runner uses an over-aggressive default timeout of 45 seconds 
for tests. For some tests which comprise a series of sub-tests, this 
is a bit too short. For example, I regularly see:

not ok 30 selftests: bpf: test_tunnel.sh # TIMEOUT

not ok 37 selftests: bpf: test_lwt_ip_encap.sh # TIMEOUT

not ok 39 selftests: bpf: test_tc_tunnel.sh # TIMEOUT

not ok 41 selftests: bpf: test_xdping.sh # TIMEOUT

Theses tests all share the characteristic that they consist of a set of
subtests, and while some sleeps could potentially be trimmed it seems
like we may want to override the default timeout with a "settings" file 
to get more stable results. Picking magic numbers that work for everyone 
is problematic of course. timeout=0 (disable timeouts) is one answer I
suppose.  Are others hitting this, or are you adding your own settings
file with a timeout override, or perhaps invoking the tests in a way other 
than "make run_tests" in tools/testing/selftests/bpf?

2. Missing CONFIG variables in tools/testing/selftests/bpf/config. As I 
understand it the toplevel config file is supposed to specify config vars 
needed to run the associated tests.  I noticed a few absences:

Should CONFIG_IPV6_SEG6_BPF be in tools/testing/selftests/bpf/config?
Without it the helper bpf_lwt_seg6_adjust_srh is not compiled in so 
loading test_seg6_loop.o fails:

# libbpf: load bpf program failed: Invalid argument
# libbpf: -- BEGIN DUMP LOG ---
# libbpf:
# unknown func bpf_lwt_seg6_adjust_srh#75
# verification time 48 usec
# stack depth 88
# processed 90 insns (limit 1000000) max_states_per_insn 0 total_states 6 
peak_states 6 mark_read 3
#
# libbpf: -- END LOG --
# libbpf: failed to load program 'lwt_seg6local'
# libbpf: failed to load object 'test_seg6_loop.o'
# test_bpf_verif_scale:FAIL:110
# #5/21 test_seg6_loop.o:FAIL
# #5 bpf_verif_scale:FAIL

Same question for CONFIG_LIRC for test_lirc* tests; I'm seeing:

# grep: /sys/class/rc/rc0/lirc*/uevent: No such file or directory
# Usage: ./test_lirc_mode2_user /dev/lircN /dev/input/eventM
# ^[[0;31mFAIL: lirc_mode2^[[0m

...which I suspect would be fixed by having CONFIG_LIRC.

3. libbpf: XXX is not found in vmlinux BTF

A few different cases here across a bunch of tests:

# libbpf: ipv6_route is not found in vmlinux BTF
# libbpf: netlink is not found in vmlinux BTF
# libbpf: bpf_map is not found in vmlinux BTF
# libbpf: task is not found in vmlinux BTF
# libbpf: task_file is not found in vmlinux BTF
# libbpf: task is not found in vmlinux BTF
# libbpf: task is not found in vmlinux BTF
# libbpf: task is not found in vmlinux BTF
# libbpf: bpf_map is not found in vmlinux BTF
# libbpf: bpf_map is not found in vmlinux BTF
# libbpf: bpf_map is not found in vmlinux BTF
# libbpf: bpf_fentry_test1 is not found in vmlinux BTF
# libbpf: bpf_fentry_test1 is not found in vmlinux BTF
# libbpf: bpf_fentry_test1 is not found in vmlinux BTF
# libbpf: bpf_fentry_test1 is not found in vmlinux BTF
# libbpf: eth_type_trans is not found in vmlinux BTF
# libbpf: bpf_modify_return_test is not found in vmlinux BTF
# libbpf: bpf_modify_return_test is not found in vmlinux BTF
# libbpf: file_mprotect is not found in vmlinux BTF
# libbpf: __set_task_comm is not found in vmlinux BTF
# libbpf: __set_task_comm is not found in vmlinux BTF
# libbpf: hrtimer_nanosleep is not found in vmlinux BTF
# libbpf: ipv6_route is not found in vmlinux BTF
# libbpf: netlink is not found in vmlinux BTF
# libbpf: bpf_map is not found in vmlinux BTF
# libbpf: task is not found in vmlinux BTF
# libbpf: task_file is not found in vmlinux BTF
# libbpf: task is not found in vmlinux BTF
# libbpf: task is not found in vmlinux BTF
# libbpf: task is not found in vmlinux BTF
# libbpf: bpf_map is not found in vmlinux BTF
# libbpf: bpf_map is not found in vmlinux BTF
# libbpf: bpf_map is not found in vmlinux BTF
# libbpf: bpf_fentry_test1 is not found in vmlinux BTF
# libbpf: bpf_fentry_test1 is not found in vmlinux BTF
# libbpf: bpf_fentry_test1 is not found in vmlinux BTF
# libbpf: bpf_fentry_test1 is not found in vmlinux BTF
# libbpf: eth_type_trans is not found in vmlinux BTF
# libbpf: bpf_modify_return_test is not found in vmlinux BTF
# libbpf: bpf_modify_return_test is not found in vmlinux BTF
# libbpf: file_mprotect is not found in vmlinux BTF
# libbpf: __set_task_comm is not found in vmlinux BTF
# libbpf: __set_task_comm is not found in vmlinux BTF
# libbpf: hrtimer_nanosleep is not found in vmlinux BTF

The strange thing is I'm running with the latest LLVM/clang
from llvm-project.git, installed libbpf/bpftool from the kernel 
build, specified CONFIG_DEBUG_INFO_BTF etc and built BTF with pahole 1.16.
Here's an example failure for fentry_test:

./test_progs -vvv -t fentry_test
libbpf: loading object 'fentry_test' from buffer
libbpf: section(1) .strtab, size 489, link 0, flags 0, type=3
libbpf: skip section(1) .strtab
libbpf: section(2) .text, size 0, link 0, flags 6, type=1
libbpf: skip section(2) .text
libbpf: section(3) fentry/bpf_fentry_test1, size 72, link 0, flags 6, 
type=1
libbpf: found program fentry/bpf_fentry_test1
libbpf: section(4) .relfentry/bpf_fentry_test1, size 16, link 33, flags 0, 
type=9
libbpf: section(5) fentry/bpf_fentry_test2, size 112, link 0, flags 6, 
type=1
libbpf: found program fentry/bpf_fentry_test2
libbpf: section(6) .relfentry/bpf_fentry_test2, size 16, link 33, flags 0, 
type=9
libbpf: section(7) fentry/bpf_fentry_test3, size 160, link 0, flags 6, 
type=1
libbpf: found program fentry/bpf_fentry_test3
libbpf: section(8) .relfentry/bpf_fentry_test3, size 16, link 33, flags 0, 
type=9
libbpf: section(9) fentry/bpf_fentry_test4, size 136, link 0, flags 6, 
type=1
libbpf: found program fentry/bpf_fentry_test4
libbpf: section(10) .relfentry/bpf_fentry_test4, size 16, link 33, flags 
0, type=9
libbpf: section(11) fentry/bpf_fentry_test5, size 152, link 0, flags 6, 
type=1
libbpf: found program fentry/bpf_fentry_test5
libbpf: section(12) .relfentry/bpf_fentry_test5, size 16, link 33, flags 
0, type=9
libbpf: section(13) fentry/bpf_fentry_test6, size 168, link 0, flags 6, 
type=1
libbpf: found program fentry/bpf_fentry_test6
libbpf: section(14) .relfentry/bpf_fentry_test6, size 16, link 33, flags 
0, type=9
libbpf: section(15) license, size 4, link 0, flags 3, type=1
libbpf: license of fentry_test is GPL
libbpf: section(16) .bss, size 48, link 0, flags 3, type=8
libbpf: section(17) .debug_loc, size 1122, link 0, flags 0, type=1
libbpf: skip section(17) .debug_loc
libbpf: section(18) .rel.debug_loc, size 352, link 33, flags 0, type=9
libbpf: skip relo .rel.debug_loc(18) for section(17)
libbpf: section(19) .debug_abbrev, size 228, link 0, flags 0, type=1
libbpf: skip section(19) .debug_abbrev
libbpf: section(20) .debug_info, size 1162, link 0, flags 0, type=1
libbpf: skip section(20) .debug_info
libbpf: section(21) .rel.debug_info, size 224, link 33, flags 0, type=9
libbpf: skip relo .rel.debug_info(21) for section(20)
libbpf: section(22) .debug_ranges, size 416, link 0, flags 0, type=1
libbpf: skip section(22) .debug_ranges
libbpf: section(23) .rel.debug_ranges, size 640, link 33, flags 0, type=9
libbpf: skip relo .rel.debug_ranges(23) for section(22)
libbpf: section(24) .debug_str, size 445, link 0, flags 30, type=1
libbpf: skip section(24) .debug_str
libbpf: section(25) .BTF, size 1610, link 0, flags 0, type=1
libbpf: section(26) .rel.BTF, size 112, link 33, flags 0, type=9
libbpf: skip relo .rel.BTF(26) for section(25)
libbpf: section(27) .BTF.ext, size 984, link 0, flags 0, type=1
libbpf: section(28) .rel.BTF.ext, size 896, link 33, flags 0, type=9
libbpf: skip relo .rel.BTF.ext(28) for section(27)
libbpf: section(29) .debug_frame, size 160, link 0, flags 0, type=1
libbpf: skip section(29) .debug_frame
libbpf: section(30) .rel.debug_frame, size 96, link 33, flags 0, type=9
libbpf: skip relo .rel.debug_frame(30) for section(29)
libbpf: section(31) .debug_line, size 435, link 0, flags 0, type=1
libbpf: skip section(31) .debug_line
libbpf: section(32) .rel.debug_line, size 96, link 33, flags 0, type=9
libbpf: skip relo .rel.debug_line(32) for section(31)
libbpf: section(33) .symtab, size 720, link 1, flags 0, type=2
libbpf: looking for externs among 30 symbols...
libbpf: collected 0 externs total
libbpf: map 'fentry_t.bss' (global data): at sec_idx 16, offset 0, flags 
400.
libbpf: map 0 is "fentry_t.bss"
libbpf: collecting relocating info for: 'fentry/bpf_fentry_test1'
libbpf: relo for shdr 16, symb 19, value 0, type 1, bind 1, name 99 
('test1_result'), insn 4
libbpf: found data map 0 (fentry_t.bss, sec 16, off 0) for insn 4
libbpf: collecting relocating info for: 'fentry/bpf_fentry_test2'
libbpf: relo for shdr 16, symb 21, value 8, type 1, bind 1, name 86 
('test2_result'), insn 9
libbpf: found data map 0 (fentry_t.bss, sec 16, off 0) for insn 9
libbpf: collecting relocating info for: 'fentry/bpf_fentry_test3'
libbpf: relo for shdr 16, symb 23, value 16, type 1, bind 1, name 73 
('test3_result'), insn 15
libbpf: found data map 0 (fentry_t.bss, sec 16, off 0) for insn 15
libbpf: collecting relocating info for: 'fentry/bpf_fentry_test4'
libbpf: relo for shdr 16, symb 25, value 24, type 1, bind 1, name 60 
('test4_result'), insn 12
libbpf: found data map 0 (fentry_t.bss, sec 16, off 0) for insn 12
libbpf: collecting relocating info for: 'fentry/bpf_fentry_test5'
libbpf: relo for shdr 16, symb 27, value 32, type 1, bind 1, name 47 
('test5_result'), insn 14
libbpf: found data map 0 (fentry_t.bss, sec 16, off 0) for insn 14
libbpf: collecting relocating info for: 'fentry/bpf_fentry_test6'
libbpf: relo for shdr 16, symb 29, value 40, type 1, bind 1, name 34 
('test6_result'), insn 16
libbpf: found data map 0 (fentry_t.bss, sec 16, off 0) for insn 16
libbpf: loading kernel BTF '/sys/kernel/btf/vmlinux': 0
libbpf: map 'fentry_t.bss': created successfully, fd=4
libbpf: bpf_fentry_test1 is not found in vmlinux BTF
libbpf: failed to load object 'fentry_test'
libbpf: failed to load BPF skeleton 'fentry_test': -2
test_fentry_test:FAIL:fentry_skel_load fentry skeleton failed
#19 fentry_test:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

What's odd is that symbols are being found when loading via 
bpf_load_xattr(); the common thread in the above seems to be BPF 
skeleton-based open+load. Is there anything else I should check
to further debug this?

4. Some of the tests rely on /dev/tcp - support for it seems to only
be in  newer bash; tests which spawn nc servers and wait on data 
transfers via /dev/tcp hang as a result (timeouts don't seem to
kill things either). Would it be reasonable to have tests fall back to
using nc where possible if /dev/tcp is not present, or perhaps
fail early?

Apologies if I've missed any discussion of any of the above. Thanks!

Alan

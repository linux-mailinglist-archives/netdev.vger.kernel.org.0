Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F2E455B00
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344407AbhKRL5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:57:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1344293AbhKRLzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:55:46 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIADNMw016359;
        Thu, 18 Nov 2021 11:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=raQrKJcjwwJ+QrvYCusBI+R/6kx3BbpJp/Ak1o8s4cY=;
 b=iJIzpPilq65ZDUjz2FdTFhjOq71o1dPCkGmX36DMOQxpbQBYowgu3UCt+ZgYKgH6SHkN
 PZNAmBxx1BQWh6rSeuWq1KCPGSGB9s4EA2Fnbb0kOyMMqN4oRHCmN10Z0tysoL8zwL7V
 IM5YwSL1osPlzVy1xzlKwjh27bU/UigWhfcQWVUip4mBYh/No84Tex+avYlr97GQR78W
 Zq/5qdVYhDTA3SqGGDHOPkrPE01sSXLfqE+2iUdZB9p71ol8cULZSoRTmAZv0JVbWtIb
 5+XCjzvX6Gt9Ge/73gU/vRc7uR7XOqSzeeCmHBy3tunXGgvk4KrIaMJKl7AaDTBfBATp CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cdmw0a0vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 11:52:32 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AIAGWAg027101;
        Thu, 18 Nov 2021 11:52:32 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cdmw0a0v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 11:52:32 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIBlgND029174;
        Thu, 18 Nov 2021 11:52:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3ca50ak7ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 11:52:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIBqQrg1245790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 11:52:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88C52A406E;
        Thu, 18 Nov 2021 11:52:26 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDF2FA4057;
        Thu, 18 Nov 2021 11:52:25 +0000 (GMT)
Received: from vm.lan (unknown [9.145.38.29])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Nov 2021 11:52:25 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     bpf@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shuah Khan <shuah@kernel.org>, kernel-team@cloudflare.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH bpf] selfetests/bpf: Adapt vmtest.sh to s390 libbpf CI changes
Date:   Thu, 18 Nov 2021 12:52:25 +0100
Message-Id: <20211118115225.1349726-1-iii@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W_vaYXVuSC_RM7rPnt9zfDkVSWCWLUmk
X-Proofpoint-GUID: mzFoG6PomZCKaAnX2eYs5DWNf1YFUjQk
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_05,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180067
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[1] added s390 support to libbpf CI and added an ${ARCH} prefix to a
number of paths and identifiers in libbpf GitHub repo, which vmtest.sh
relies upon. Update these and make use of the new s390 support.

[1] https://github.com/libbpf/libbpf/pull/204

Co-developed-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/vmtest.sh | 46 ++++++++++++++++++---------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/vmtest.sh b/tools/testing/selftests/bpf/vmtest.sh
index 027198768fad..5e43c79ddc6e 100755
--- a/tools/testing/selftests/bpf/vmtest.sh
+++ b/tools/testing/selftests/bpf/vmtest.sh
@@ -4,17 +4,34 @@
 set -u
 set -e
 
-# This script currently only works for x86_64, as
-# it is based on the VM image used by the BPF CI which is
-# x86_64.
-QEMU_BINARY="${QEMU_BINARY:="qemu-system-x86_64"}"
-X86_BZIMAGE="arch/x86/boot/bzImage"
+# This script currently only works for x86_64 and s390x, as
+# it is based on the VM image used by the BPF CI, which is
+# available only for these architectures.
+ARCH="$(uname -m)"
+case "${ARCH}" in
+s390x)
+	QEMU_BINARY=qemu-system-s390x
+	QEMU_CONSOLE="ttyS1"
+	QEMU_FLAGS=(-smp 2)
+	BZIMAGE="arch/s390/boot/compressed/vmlinux"
+	;;
+x86_64)
+	QEMU_BINARY=qemu-system-x86_64
+	QEMU_CONSOLE="ttyS0,115200"
+	QEMU_FLAGS=(-cpu host -smp 8)
+	BZIMAGE="arch/x86/boot/bzImage"
+	;;
+*)
+	echo "Unsupported architecture"
+	exit 1
+	;;
+esac
 DEFAULT_COMMAND="./test_progs"
 MOUNT_DIR="mnt"
 ROOTFS_IMAGE="root.img"
 OUTPUT_DIR="$HOME/.bpf_selftests"
-KCONFIG_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/latest.config"
-KCONFIG_API_URL="https://api.github.com/repos/libbpf/libbpf/contents/travis-ci/vmtest/configs/latest.config"
+KCONFIG_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/config-latest.${ARCH}"
+KCONFIG_API_URL="https://api.github.com/repos/libbpf/libbpf/contents/travis-ci/vmtest/configs/config-latest.${ARCH}"
 INDEX_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/INDEX"
 NUM_COMPILE_JOBS="$(nproc)"
 LOG_FILE_BASE="$(date +"bpf_selftests.%Y-%m-%d_%H-%M-%S")"
@@ -85,7 +102,7 @@ newest_rootfs_version()
 {
 	{
 	for file in "${!URLS[@]}"; do
-		if [[ $file =~ ^libbpf-vmtest-rootfs-(.*)\.tar\.zst$ ]]; then
+		if [[ $file =~ ^"${ARCH}"/libbpf-vmtest-rootfs-(.*)\.tar\.zst$ ]]; then
 			echo "${BASH_REMATCH[1]}"
 		fi
 	done
@@ -102,7 +119,7 @@ download_rootfs()
 		exit 1
 	fi
 
-	download "libbpf-vmtest-rootfs-$rootfsversion.tar.zst" |
+	download "${ARCH}/libbpf-vmtest-rootfs-$rootfsversion.tar.zst" |
 		zstd -d | sudo tar -C "$dir" -x
 }
 
@@ -224,13 +241,12 @@ EOF
 		-nodefaults \
 		-display none \
 		-serial mon:stdio \
-		-cpu host \
+		"${qemu_flags[@]}" \
 		-enable-kvm \
-		-smp 8 \
 		-m 4G \
 		-drive file="${rootfs_img}",format=raw,index=1,media=disk,if=virtio,cache=none \
 		-kernel "${kernel_bzimage}" \
-		-append "root=/dev/vda rw console=ttyS0,115200"
+		-append "root=/dev/vda rw console=${QEMU_CONSOLE}"
 }
 
 copy_logs()
@@ -282,7 +298,7 @@ main()
 	local kernel_checkout=$(realpath "${script_dir}"/../../../../)
 	# By default the script searches for the kernel in the checkout directory but
 	# it also obeys environment variables O= and KBUILD_OUTPUT=
-	local kernel_bzimage="${kernel_checkout}/${X86_BZIMAGE}"
+	local kernel_bzimage="${kernel_checkout}/${BZIMAGE}"
 	local command="${DEFAULT_COMMAND}"
 	local update_image="no"
 	local exit_command="poweroff -f"
@@ -337,13 +353,13 @@ main()
 		if is_rel_path "${O}"; then
 			O="$(realpath "${PWD}/${O}")"
 		fi
-		kernel_bzimage="${O}/${X86_BZIMAGE}"
+		kernel_bzimage="${O}/${BZIMAGE}"
 		make_command="${make_command} O=${O}"
 	elif [[ "${KBUILD_OUTPUT:=""}" != "" ]]; then
 		if is_rel_path "${KBUILD_OUTPUT}"; then
 			KBUILD_OUTPUT="$(realpath "${PWD}/${KBUILD_OUTPUT}")"
 		fi
-		kernel_bzimage="${KBUILD_OUTPUT}/${X86_BZIMAGE}"
+		kernel_bzimage="${KBUILD_OUTPUT}/${BZIMAGE}"
 		make_command="${make_command} KBUILD_OUTPUT=${KBUILD_OUTPUT}"
 	fi
 
-- 
2.31.1


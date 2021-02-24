Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD27324332
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 18:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbhBXRbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 12:31:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232821AbhBXRb3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 12:31:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45DBD64EC4;
        Wed, 24 Feb 2021 17:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614187847;
        bh=SEhkVYWLQg6+o1gkBlvZQOB5qQaSnoXmTG49FMTrMJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P0syLjiLTgrEsZ7k9weHMZ7krgBBH/aZn98XsCZcegLCc1osfS3StC5pSYDkucMJN
         CZZd2M2NOxGinHLZCmU7T+mpejplwMEnWlaMdgwfGBM/TlDPRuyCiuJCxh9k99k4W8
         gFpK1PxH+67+VQt5X4+f9AbidQ1lrr9KegadueElLdFV//BVPdNEgZaGby4P7o4eLl
         T9D2WZKxfjKXYVlANxdh0b8TBXVVRvENcoc/Et0mIMRoCvh9XqvbwD0ZWvHuGbKx2+
         9lAXOAfTx/2JG4JfUNWr57Kzth7T4sD6fAEzB8peTHvgwCDigXvHJEiyIe+9pUdF9x
         AERwIek0oX7Ow==
Date:   Wed, 24 Feb 2021 10:30:45 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [RFC] dwarves/pahole: Add test scripts
Message-ID: <20210224173045.GA51663@24bbad8f3778>
References: <20210223132321.220570-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223132321.220570-1-jolsa@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

Just some drive by comments. I think the idea is neat, I am always a fan
of automating more things :)

On Tue, Feb 23, 2021 at 02:23:21PM +0100, Jiri Olsa wrote:
> hi,
> I cleaned up a bit my testing scripts, that I'm using for testing
> btf encoding changes. It's far from ideal and convoluted, but let's
> have discussion if this could be kicked into something useful for
> everybody.
> 
> There are 2 scripts:
>   kernel-objects-build.sh - compiles kernel for several archs and
>                             stores vmlinux and kernel modules
> 
>   kernel-objects-test.sh  - goes through objects stored by ^^^
>                             and runs tests on each of them
> 
> The general idea is that all objects are compiled already with
> BTF debuginfo with available pahole. The test script then:
>   - takes each objects and dumps its current BTF data
>   - then create new BTF data with given pahole binary
>   - dumps the new BTF data and makes the comparison
> 
> I was thinking about support for comparing 2 pahole binaries,
> but so far that did not fit into my workflow. Normally I have
> latest globally available pahole, which is used to build the
> kernel binaries and then I'm playing with new pahole binary,
> which I'm putting to the test.
> 
> Example.. prepare vmlinux and modules for all archs:
> 
>         $ ./kernel-objects-build.sh
>         output:  /tmp/pahole.test.nsQ
>         kdir:    /home/jolsa/linux
>         pahole:  /opt/dwarves/bin/pahole
>         objects: /home/jolsa/.pahole_test_objects
> 
>         cleanup /home/jolsa/linux
>         ...
> 
> All objects are stored under ~/pahole_test_objects/ directories:
> 
>         $ ls ~/.pahole_test_objects/
>         aarch64-clang
>         aarch64-gcc
>         powerpc-gcc
>         powerpcle-gcc
>         s390x-gcc
>         x86-clang
>         x86-gcc
> 
> Each containing vmlinux and modules:
> 
> 	$ ls ~/.pahole_test_objects/x86-gcc/
> 	efivarfs.ko  iptable_nat.ko  nf_log_arp.ko  nf_log_common.ko  nf_log_ipv4.ko  nf_log_ipv6.ko
> 	vmlinux  x86_pkg_temp_thermal.ko  xt_addrtype.ko  xt_LOG.ko  xt_mark.ko  xt_MASQUERADE.ko  xt_nat.ko
> 
> Run test on all of them with new './pahole' binary:
> 
>         $ ./kernel-objects-test.sh -B ~/linux/tools/bpf/bpftool/bpftool -P ./pahole
>         pahole:  /home/jolsa/pahole/build/pahole
>         bpftool: /home/jolsa/linux/tools/bpf/bpftool/bpftool
>         base:    /tmp/pahole.test.oxv
>         objects: /home/jolsa/.pahole_test_objects
>         fail:    no
>         cleanup: yes
> 
>         test_funcs      on /home/jolsa/.pahole_test_objects/aarch64-clang/vmlinux ... OK
>         test_format_c   on /home/jolsa/.pahole_test_objects/aarch64-clang/vmlinux ... OK
>         test_btfdiff    on /home/jolsa/.pahole_test_objects/aarch64-clang/vmlinux ... FAIL
>         test_funcs      on /home/jolsa/.pahole_test_objects/aarch64-clang/8021q.ko ... OK
>         test_format_c   on /home/jolsa/.pahole_test_objects/aarch64-clang/8021q.ko ... OK
>         test_funcs      on /home/jolsa/.pahole_test_objects/aarch64-clang/act_gact.ko ... OK
>         test_format_c   on /home/jolsa/.pahole_test_objects/aarch64-clang/act_gact.ko ... OK
>         ...
> 
> There are several options that helps to set other binaries/dirs
> or stop and debug issues.
> 
> thoughts?
> 
> thanks,
> jirka
> 
> 
> ---
>  kernel-objects-build.sh | 132 +++++++++++++++++++
>  kernel-objects-test.sh  | 282 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 414 insertions(+)
>  create mode 100755 kernel-objects-build.sh
>  create mode 100755 kernel-objects-test.sh
> 
> diff --git a/kernel-objects-build.sh b/kernel-objects-build.sh
> new file mode 100755
> index 000000000000..b92729994ded
> --- /dev/null
> +++ b/kernel-objects-build.sh
> @@ -0,0 +1,132 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +set -u
> +set -e
> +
> +exec 2>&1
> +
> +OBJECTS="${HOME}/.pahole_test_objects"
> +KDIR=${HOME}/linux
> +PAHOLE=$(which pahole)
> +OUTPUT=
> +
> +usage()
> +{
> +	cat <<EOF
> +Usage: $0 [-k KERNEL] [-O OUTPUT] [-o OBJECTS]
> +
> +The script prepares vmlinux and kernel modules for different archs/C:
> +
> +  - x86 gcc/clang
> +  - arm64 gcc/clang
> +  - powerpc gcc
> +  - s390x gcc
> +
> +Options:
> +  -k) Update kernel tree directory (default HOME/linux)
> +  -O) Update temp output directory (default mktemp /tmp/pahole.test.XXX)
> +  -o) Update final objects directory (default HOME/.pahole.test.XXX)
> +
> +Make images under '/tmp/build', and place it under 'objects':
> +
> +  $ $0 -o objects -O /tmp/build/
> +
> +EOF
> +}
> +
> +build()
> +{
> +	local name=$1
> +	local opts=$2

A more robust way to handle this might be

shift
local opts=$@

> +
> +	echo "build ${name} (${OUTPUT}/output)"
> +
> +	mkdir -p ${OBJECTS}/${name}
> +	mkdir -p ${OUTPUT}
> +
> +	pushd ${KDIR}
> +	make ${opts} -j"$(nproc)" O=${OUTPUT} olddefconfig > ${OUTPUT}/output 2>&1

Then change this to

make "${opts[@]}"

shellcheck complains about implicit word splitting (and finds some other
things in the other script).

> +	scripts/config \
> +		--file ${OUTPUT}/.config \
> +		-e BPF_SYSCALL \
> +		-e DEBUG_INFO \
> +		-e DEBUG_INFO_BTF \
> +		-e FTRACE \
> +		-e FUNCTION_TRACER \
> +		>> ${OUTPUT}/output 2>&1
> +	make ${opts} -j"$(nproc)" O=${OUTPUT} PAHOLE=${PAHOLE} olddefconfig all >> ${OUTPUT}/output 2>&1
> +
> +	cp ${OUTPUT}/vmlinux ${OBJECTS}/${name}
> +	find ${OUTPUT} -name '*.ko' | xargs cp -t ${OBJECTS}/${name}
> +
> +	rm -rf ${OUTPUT}
> +	popd
> +}
> +
> +main()
> +{
> +	while getopts 'k:o:O:' opt; do
> +		case ${opt} in
> +		k)
> +			KDIR="$OPTARG"
> +			;;
> +		O)
> +			OUTPUT="$OPTARG"
> +			;;
> +		o)
> +			OBJECTS="$OPTARG"
> +			;;
> +		esac
> +	done
> +	shift $((OPTIND -1))
> +
> +	if [[ $# -ne 0 ]]; then
> +		usage
> +		exit 1
> +	fi
> +
> +        if [[ "${OUTPUT}" == "" ]]; then
> +                OUTPUT=$(mktemp -d /tmp/pahole.test.XXX)
> +        fi
> +
> +	PAHOLE=$(realpath ${PAHOLE})
> +	OBJECTS=$(realpath ${OBJECTS})
> +
> +	echo "output:  ${OUTPUT}"
> +	echo "kdir:    ${KDIR}"
> +	echo "pahole:  ${PAHOLE}"
> +	echo "objects: ${OBJECTS}"
> +	echo
> +
> +	mkdir -p ${OBJECTS}
> +
> +	echo "cleanup ${KDIR}"
> +	make -C ${KDIR} mrproper
> +
> +
> +	build x86-clang     "LLVM=1"

With that change above, you could unquote these options and just pass
them in as regular parameters.

> +	build x86-gcc       ""
> +
> +	build aarch64-clang "ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LLVM=1"
> +	build aarch64-gcc   "ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-"
> +
> +#	build powerpc-clang "ARCH=powerpc CROSS_COMPILE=powerpc64-linux-gnu- LLVM=1"
> +	build powerpc-gcc   "ARCH=powerpc CROSS_COMPILE=powerpc64-linux-gnu-"
> +
> +#	build powerpcle-clang "ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu- LLVM=1"
> +	build powerpcle-gcc   "ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu-"
> +
> +#	build s390x-clang   "ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- LLVM=1"

powerpc64le and s390 can build with CC=clang, instead of LLVM=1.

I will see if I can give this a run locally over the next week or so.

Cheers,
Nathan

> +	build s390x-gcc     "ARCH=s390 CROSS_COMPILE=s390x-linux-gnu-"
> +}
> +
> +catch()
> +{
> +	local exit_code=$1
> +	exit ${exit_code}
> +}
> +
> +trap 'catch "$?"' EXIT
> +
> +main "$@"
> diff --git a/kernel-objects-test.sh b/kernel-objects-test.sh
> new file mode 100755
> index 000000000000..a34c22c2eb09
> --- /dev/null
> +++ b/kernel-objects-test.sh
> @@ -0,0 +1,282 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +set -u
> +
> +exec 2>&1
> +
> +PAHOLE=$(which pahole)
> +BPFTOOL=$(which bpftool)
> +BTFDIFF=$(which btfdiff)
> +
> +OBJECTS="$HOME/.pahole_test_objects"
> +CLEANUP="yes"
> +BASE=
> +FAIL="no"
> +
> +function test_funcs()
> +{
> +	local vmlinux=$1
> +	local obj=$2
> +	local err=0
> +
> +	cp ${obj} ${BASE}/object
> +
> +	if [[ ${obj} == *.ko ]]; then
> +		${BPFTOOL} --base ${vmlinux} btf dump file ${BASE}/object > ${BASE}/btf.old
> +		${PAHOLE} -V -J --btf_base ${vmlinux} ${BASE}/object > ${BASE}/output
> +		${BPFTOOL} --base ${vmlinux} btf dump file ${BASE}/object > ${BASE}/btf.new
> +	else
> +		${BPFTOOL} btf dump file ${BASE}/object > ${BASE}/btf.old
> +		${PAHOLE} -V -J ${BASE}/object > ${BASE}/output
> +		${BPFTOOL} btf dump file ${BASE}/object > ${BASE}/btf.new
> +	fi
> +
> +	diff -puw ${BASE}/btf.old ${BASE}/btf.new > ${BASE}/diff.all
> +	if [ $? -ne 0 ]; then
> +		funcs_old=${BASE}/funcs.old
> +		funcs_new=${BASE}/funcs.new
> +
> +		cat ${BASE}/btf.old | grep 'FUNC ' | awk '{ print $3 }' | sort | uniq > ${funcs_old}
> +		cat ${BASE}/btf.new | grep 'FUNC ' | awk '{ print $3 }' | sort | uniq > ${funcs_new}
> +
> +		diff -puw ${funcs_old} ${funcs_new} > ${BASE}/diff.funcs
> +	fi
> +
> +	if [[ $? -ne 0 ]]; then
> +		err=1
> +	fi
> +
> +	return ${err};
> +}
> +
> +function test_format_c()
> +{
> +	local vmlinux=$1
> +	local obj=$2
> +	local err=0
> +
> +	cp ${obj} ${BASE}/object
> +
> +	if [[ ${obj} == *.ko ]]; then
> +		${BPFTOOL} --base ${vmlinux} btf dump file ${BASE}/object format c > ${BASE}/c.old
> +		${PAHOLE} -V -J --btf_base ${vmlinux} ${BASE}/object > ${BASE}/output
> +		${BPFTOOL} --base ${vmlinux} btf dump file ${BASE}/object format c > ${BASE}/c.new
> +	else
> +		${BPFTOOL} btf dump file ${BASE}/object format c > ${BASE}/c.old
> +		${PAHOLE} -V -J ${BASE}/object > ${BASE}/output
> +		${BPFTOOL} btf dump file ${BASE}/object format c > ${BASE}/c.new
> +	fi
> +
> +	diff -puw ${BASE}/c.old ${BASE}/c.new > ${BASE}/diff.all
> +	if [[ $? -ne 0 ]]; then
> +		err=1
> +	fi
> +
> +	return ${err};
> +}
> +
> +function test_btfdiff()
> +{
> +	local vmlinux=$1
> +	local obj=$2
> +	local err=0
> +
> +	if [[ -x ${BTFDIFF} ]]; then
> +		${BTFDIFF} ${obj} > ${BASE}/output
> +		if [[ -s "${BASE}/output" ]]; then
> +			err=1
> +		fi
> +	else
> +		err=2
> +	fi
> +
> +	return ${err}
> +}
> +
> +usage()
> +{
> +	cat <<EOF
> +Usage: $0 [-f] [-o object] [-O objects] [-b BASE] [-P PAHOLE] [-B BPFTOOL] -- [test]
> +
> +The script runs tests on objects with BTF data.
> +
> +Options:
> +  -f) Stop on failure
> +  -o) Run tests on specific objects
> +  -O) Update the root objects directory (default HOME/.pahole_test_objects)
> +  -b) Update work base/temporary directory (default mktemp -d /tmp/pahole.test.XXX)
> +  -P) Update pahole path (default which pahole)
> +  -B) Update bpftool path (default which bpftool)
> +
> +Test image under 'objects':
> +
> +  $ $0 -O objects/
> +
> +Test specific image (objects/aarch64-clang) and stop on failure:
> +
> +  $ $0 -o o objects/aarch64-clang -f
> +
> +Run specific test (test_format_c):
> +
> +  $ $0 -o o objects/aarch64-clang -f test_format_c
> +EOF
> +}
> +
> +do_test()
> +{
> +	local test_name=$1
> +	local vmlinux=$2
> +	local obj=$3
> +
> +	printf "%-15s on %s ... " "${test_name}"  "${obj}"
> +
> +	eval ${test_name} ${vmlinux} ${obj}
> +	local err=$?
> +
> +	case ${err} in
> +	0)
> +		echo "OK"
> +		;;
> +	1)
> +		echo "FAIL"
> +		;;
> +	2)
> +		echo "SKIP"
> +		;;
> +	esac
> +
> +	if [[ ${err} -eq 1 && "${FAIL}" == "yes" ]]; then
> +		exit 1
> +	fi
> +
> +	return ${err}
> +}
> +
> +run_tests()
> +{
> +	local vmlinux=$1
> +	local obj=$2
> +	local test_name=$3
> +
> +	if [[ "${test_name}" != "all" ]]; then
> +		do_test ${test_name} ${vmlinux} ${obj}
> +	else
> +		do_test test_funcs ${vmlinux} ${obj}
> +		do_test test_format_c ${vmlinux} ${obj}
> +
> +		# btfdiff is only for vmlinux
> +		if [[ ${obj} != *.ko ]]; then
> +			do_test test_btfdiff ${vmlinux} ${obj}
> +		fi
> +	fi
> +}
> +
> +do_obj()
> +{
> +	local obj=$1
> +	local test_name=$2
> +	local vmlinux=${obj}/vmlinux
> +
> +	run_tests ${vmlinux} ${vmlinux} ${test_name}
> +
> +	for kmod in $(ls ${obj}/*.ko); do
> +		run_tests ${vmlinux} ${kmod} ${test_name}
> +	done
> +}
> +
> +main()
> +{
> +	local test_name="all"
> +
> +	while getopts 'b:o:dhP:B:fO:' opt; do
> +		case ${opt} in
> +		f)
> +			FAIL="yes"
> +			CLEANUP="no"
> +			;;
> +		o)
> +			obj="$OPTARG"
> +			;;
> +		O)
> +			OBJECTS="$OPTARG"
> +			;;
> +		b)
> +			BASE="$OPTARG"
> +			;;
> +		P)
> +			PAHOLE="$OPTARG"
> +			;;
> +		B)
> +			BPFTOOL="$OPTARG"
> +			;;
> +		h)
> +			usage
> +			exit 0
> +			;;
> +		\? )
> +			echo "Invalid Option: -$OPTARG"
> +			usage
> +			exit 1
> +			;;
> +		: )
> +			echo "Invalid Option: -$OPTARG requires an argument"
> +			usage
> +			exit 1
> +			;;
> +		esac
> +	done
> +	shift $((OPTIND -1))
> +
> +	if [[ $# -gt 1 ]]; then
> +		echo "Invalid test: $@"
> +		usage
> +		exit 1
> +	fi
> +
> +	if [[ $# -eq 1 ]]; then
> +		test_name="$@"
> +	fi
> +
> +	if [[ "${BASE}" == "" ]]; then
> +		BASE=$(mktemp -d /tmp/pahole.test.XXX)
> +	else
> +		mkdir -p ${BASE}
> +	fi
> +
> +	PAHOLE=$(realpath ${PAHOLE})
> +	BPFTOOL=$(realpath ${BPFTOOL})
> +	OBJECTS=$(realpath ${OBJECTS})
> +
> +	echo "pahole:  ${PAHOLE}"
> +	echo "bpftool: ${BPFTOOL}"
> +	echo "base:    ${BASE}"
> +	echo "objects: ${obj:-${OBJECTS}}"
> +	echo "fail:    ${FAIL}"
> +	echo "cleanup: ${CLEANUP}"
> +	echo
> +
> +	if [[ "${obj:=""}" != "" ]]; then
> +		do_obj ${obj} ${test_name}
> +	else
> +		for obj in $(ls ${OBJECTS}); do
> +			do_obj ${OBJECTS}/${obj} ${test_name}
> +		done
> +	fi
> +}
> +
> +catch()
> +{
> +	local exit_code=$1
> +	if [[ "${BASE:=""}" != "" && "${CLEANUP}" == "yes" ]]; then
> +		rm -rf ${BASE}
> +	else
> +		echo
> +		echo "Keeping test data in: ${BASE}"
> +	fi
> +	exit ${exit_code}
> +}
> +
> +trap 'catch "$?"' EXIT
> +
> +main "$@"
> -- 
> 2.29.2
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE27264019B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbiLBIKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiLBIKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:10:05 -0500
Received: from out-190.mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8581DAE4F3
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:10:03 -0800 (PST)
Message-ID: <cb1d8ee5-c5b4-261b-7cbb-459dbbe700b9@linux.dev>
Date:   Fri, 2 Dec 2022 00:09:53 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next,v3 4/4] selftests/bpf: add xfrm_info tests
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org, liuhangbin@gmail.com,
        lixiaoyan@google.com
References: <20221201211425.1528197-1-eyal.birger@gmail.com>
 <20221201211425.1528197-5-eyal.birger@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221201211425.1528197-5-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/22 1:14 PM, Eyal Birger wrote:
> Test the xfrm_info kfunc helpers.
> 
> Note: the tests require support for xfrmi "external" mode in iproute2.

Not needed now. Please update the commit message.

The test is failing on platform that has no kfunc support yet.  Please check the 
BPF CI result in patchwork after posting to ensure the tests run well:
https://patchwork.kernel.org/project/netdevbpf/patch/20221201211425.1528197-5-eyal.birger@gmail.com/

This test needs to be added to the DENYLIST.<arch> for the not yet supported 
platform.  Please refer to selftests/bpf/README.rst for details.

[ ... ]

> +#define SYS_NOFAIL(fmt, ...)					\
> +	({							\
> +		char cmd[1024];					\
> +		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
> +		system(cmd);					\
> +	})
> +
> +static int attach_tc_prog(struct bpf_tc_hook *hook, int igr_fd, int egr_fd)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts1, .handle = 1,
> +			    .priority = 1, .prog_fd = igr_fd);
> +	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts2, .handle = 1,
> +			    .priority = 1, .prog_fd = egr_fd);

s/DECLARE_LIBBPF_OPTS/LIBBPF_OPTS/

DECLARE_ is a legacy naming in libbpf_legacy.h

[ ... ]

> +static int setup_xfrmi_external_dev(const char *ns)
> +{
> +	struct {
> +		struct nlmsghdr nh;
> +		struct ifinfomsg info;
> +		unsigned char data[128];
> +	} req;
> +	struct rtattr *link_info, *info_data;
> +	struct nstoken *nstoken;
> +	int ret = -1, sock = 0;

sock = -1;

> +	struct nlmsghdr *nh;
> +
> +	memset(&req, 0, sizeof(req));
> +	nh = &req.nh;
> +	nh->nlmsg_len = NLMSG_LENGTH(sizeof(req.info));
> +	nh->nlmsg_type = RTM_NEWLINK;
> +	nh->nlmsg_flags |= NLM_F_CREATE | NLM_F_REQUEST;
> +
> +	rtattr_add_str(nh, IFLA_IFNAME, "ipsec0");
> +	link_info = rtattr_begin(nh, IFLA_LINKINFO);
> +	rtattr_add_str(nh, IFLA_INFO_KIND, "xfrm");
> +	info_data = rtattr_begin(nh, IFLA_INFO_DATA);
> +	rtattr_add(nh, IFLA_XFRM_COLLECT_METADATA, 0);
> +	rtattr_end(nh, info_data);
> +	rtattr_end(nh, link_info);
> +
> +	nstoken = open_netns(ns);

Please check error.

> +
> +	sock = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, NETLINK_ROUTE);
> +	if (!ASSERT_GT(sock, 0, "netlink socket"))

s/_GT/_GE/

> +		goto Exit;

Please run checkpatch.pl...

CHECK: Avoid CamelCase: <Exit>
#301: FILE: tools/testing/selftests/bpf/prog_tests/xfrm_info.c:250:
+		goto Exit;

> +	ret = send(sock, nh, nh->nlmsg_len, 0);
> +	if (!ASSERT_EQ(ret, nh->nlmsg_len, "netlink send length"))
> +		goto Exit;
> +
> +	ret = 0;
> +Exit:
> +	if (sock)

if (sock != -1) ...

> +		close(sock);
> +	close_netns(nstoken);
> +	return ret;
> +}
> +
> +static int config_overlay(void)
> +{
> +	if (setup_xfrm_tunnel(NS0, NS1, IP4_ADDR_VETH01, IP4_ADDR_VETH10,
> +			      IF_ID_0_TO_1, IF_ID_1))
> +		goto fail;
> +	if (setup_xfrm_tunnel(NS0, NS2, IP4_ADDR_VETH02, IP4_ADDR_VETH20,
> +			      IF_ID_0_TO_2, IF_ID_2))
> +		goto fail;
> +
> +	/* Older iproute2 doesn't support this option */
> +	if (!ASSERT_OK(setup_xfrmi_external_dev(NS0), "xfrmi"))
> +		goto fail;
> +
> +	SYS("ip -net " NS0 " addr add 192.168.1.100/24 dev ipsec0");
> +	SYS("ip -net " NS0 " link set dev ipsec0 up");
> +
> +	SYS("ip -net " NS1 " link add ipsec0 type xfrm if_id %d", IF_ID_1);
> +	SYS("ip -net " NS1 " addr add 192.168.1.200/24 dev ipsec0");
> +	SYS("ip -net " NS1 " link set dev ipsec0 up");
> +
> +	SYS("ip -net " NS2 " link add ipsec0 type xfrm if_id %d", IF_ID_2);
> +	SYS("ip -net " NS2 " addr add 192.168.1.200/24 dev ipsec0");
> +	SYS("ip -net " NS2 " link set dev ipsec0 up");
> +
> +	return 0;
> +fail:
> +	return -1;
> +}
> +
> +static int test_ping(int family, const char *addr)
> +{
> +	SYS("%s %s %s > /dev/null", ping_command(family), PING_ARGS, addr);
> +	return 0;
> +fail:
> +	return -1;
> +}
> +
> +static int test_xfrm_ping(struct xfrm_info *skel, u32 if_id)
> +{
> +	skel->bss->req_if_id = if_id;
> +
> +	if (test_ping(AF_INET, "192.168.1.200"))

nit. Directly do SYS() here to avoid another reading detour to test_ping() which 
is almost a one liner and only used once here.

> +		return -1;
> +
> +	if (!ASSERT_EQ(skel->bss->resp_if_id, if_id, "if_id"))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static void _test_xfrm_info(void)
> +{
> +	int get_xfrm_info_prog_fd, set_xfrm_info_prog_fd;
> +	struct xfrm_info *skel = NULL;
> +	struct nstoken *nstoken = NULL;
> +	int ifindex = -1;

nit. Unnecessary init.  Nonthing to cleanup at the label "done:" and it is not a 
return value also.  will be easier to review.

> +	DECLARE_LIBBPF_OPTS(bpf_tc_hook, tc_hook,
> +			    .attach_point = BPF_TC_INGRESS);
> +
> +	/* load and attach bpf progs to ipsec dev tc hook point */
> +	skel = xfrm_info__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "xfrm_info__open_and_load"))
> +		goto done;
> +	nstoken = open_netns(NS0);

Check error.

> +	ifindex = if_nametoindex("ipsec0");
> +	if (!ASSERT_NEQ(ifindex, 0, "ipsec0 ifindex"))
> +		goto done;
> +	tc_hook.ifindex = ifindex;
> +	set_xfrm_info_prog_fd = bpf_program__fd(skel->progs.set_xfrm_info);
> +	get_xfrm_info_prog_fd = bpf_program__fd(skel->progs.get_xfrm_info);
> +	if (!ASSERT_GE(set_xfrm_info_prog_fd, 0, "bpf_program__fd"))
> +		goto done;
> +	if (!ASSERT_GE(get_xfrm_info_prog_fd, 0, "bpf_program__fd"))
> +		goto done;
> +	if (attach_tc_prog(&tc_hook, get_xfrm_info_prog_fd,
> +			   set_xfrm_info_prog_fd))
> +		goto done;
> +	if (!ASSERT_EQ(test_xfrm_ping(skel, IF_ID_0_TO_1), 0, "ping " NS1))
> +		goto done;
> +	if (!ASSERT_EQ(test_xfrm_ping(skel, IF_ID_0_TO_2), 0, "ping " NS2))
> +		goto done;
> +
> +done:
> +	if (nstoken)
> +		close_netns(nstoken);
> +	if (skel)
> +		xfrm_info__destroy(skel);
> +}
> +
> +void test_xfrm_info(void)
> +{
> +	cleanup();
> +
> +	if (!ASSERT_OK(config_underlay(), "config_underlay"))

cleanup() is needed on error.

> +		return;
> +	if (!ASSERT_OK(config_overlay(), "config_overlay"))

Same here.

> +		return;
> +
> +	if (test__start_subtest("xfrm_info"))
> +		_test_xfrm_info();
> +
> +	cleanup();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/xfrm_info.c b/tools/testing/selftests/bpf/progs/xfrm_info.c
> new file mode 100644
> index 000000000000..908579310bf9
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/xfrm_info.c
> @@ -0,0 +1,40 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <linux/pkt_cls.h>
> +#include <bpf/bpf_helpers.h>
> +
> +__u32 req_if_id;
> +__u32 resp_if_id;
> +
> +struct bpf_xfrm_info {
> +	__u32 if_id;
> +	int link;
> +} __attribute__((preserve_access_index));
> +
> +int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
> +			  const struct bpf_xfrm_info *from) __ksym;
> +int bpf_skb_get_xfrm_info(struct __sk_buff *skb_ctx,
> +			  struct bpf_xfrm_info *to) __ksym;
> +
> +SEC("tc")
> +int set_xfrm_info(struct __sk_buff *skb)
> +{
> +	struct bpf_xfrm_info info = { .if_id = req_if_id };
> +
> +	return bpf_skb_set_xfrm_info(skb, &info) ? TC_ACT_SHOT : TC_ACT_UNSPEC;

Add these TC_ACT_* to bpf_tracing_net.h and then vmlinux.h can be used.  Take a 
look at some of the bpf_tracing_net.h in selftests.

> +}
> +
> +SEC("tc")
> +int get_xfrm_info(struct __sk_buff *skb)
> +{
> +	struct bpf_xfrm_info info = {};
> +
> +	if (bpf_skb_get_xfrm_info(skb, &info) < 0)
> +		return TC_ACT_SHOT;
> +
> +	resp_if_id = info.if_id;
> +
> +	return TC_ACT_UNSPEC;
> +}
> +
> +char _license[] SEC("license") = "GPL";


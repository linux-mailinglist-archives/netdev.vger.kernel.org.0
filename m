Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A8B6549CF
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 01:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiLWAkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 19:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiLWAkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 19:40:11 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6476BDFD0;
        Thu, 22 Dec 2022 16:40:09 -0800 (PST)
Message-ID: <18bed458-0128-d434-8b7a-bf676a0ea863@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671756008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fX/c8fHgpaEeP+jTMKklT1dxGwskC/LOXEHlmHk88kE=;
        b=rkQmv4X05cqZPyaz3uWk8QtcIFtAMhYFgZR9tImj7KS79kUsVaiHPgK7hX2sHOcmNtUXb6
        uzKUqrq7qudiqxpU9wklheK7XEWQ2kyMhAH82EGq+UFcMeQksx6PaWV3cbvc2MQp1ZD+ka
        Uvd0XyHecigSIVy0hbYh3KImeA39THg=
Date:   Thu, 22 Dec 2022 16:40:03 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v5 11/17] selftests/bpf: Verify xdp_metadata
 xdp->af_xdp path
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20221220222043.3348718-1-sdf@google.com>
 <20221220222043.3348718-12-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221220222043.3348718-12-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/22 2:20 PM, Stanislav Fomichev wrote:
> +static int open_xsk(const char *ifname, struct xsk *xsk)
> +{
> +	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
> +	const struct xsk_socket_config socket_config = {
> +		.rx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
> +		.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
> +		.libbpf_flags = XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD,
> +		.xdp_flags = XDP_FLAGS,
> +		.bind_flags = XDP_COPY,
> +	};
> +	const struct xsk_umem_config umem_config = {
> +		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
> +		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
> +		.frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
> +		.flags = XDP_UMEM_UNALIGNED_CHUNK_FLAG,
> +	};
> +	__u32 idx;
> +	u64 addr;
> +	int ret;
> +	int i;
> +
> +	xsk->umem_area = mmap(NULL, UMEM_SIZE, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
> +	if (!ASSERT_NEQ(xsk->umem_area, MAP_FAILED, "mmap"))
> +		return -1;
> +
> +	ret = xsk_umem__create(&xsk->umem,
> +			       xsk->umem_area, UMEM_SIZE,
> +			       &xsk->fill,
> +			       &xsk->comp,
> +			       &umem_config);
> +	if (!ASSERT_OK(ret, "xsk_umem__create"))
> +		return ret;
> +
> +	ret = xsk_socket__create(&xsk->socket, ifname, QUEUE_ID,
> +				 xsk->umem,
> +				 &xsk->rx,
> +				 &xsk->tx,
> +				 &socket_config);
> +	if (!ASSERT_OK(ret, "xsk_socket__create"))
> +		return ret;
> +
> +	/* First half of umem is for TX. This way address matches 1-to-1
> +	 * to the completion queue index.
> +	 */
> +
> +	for (i = 0; i < UMEM_NUM / 2; i++) {
> +		addr = i * UMEM_FRAME_SIZE;
> +		printf("%p: tx_desc[%d] -> %lx\n", xsk, i, addr);

Do you still need this verbose printf which is in a loop?  Also, how about other 
printf in this test?

> +	}
> +
> +	/* Second half of umem is for RX. */
> +
> +	ret = xsk_ring_prod__reserve(&xsk->fill, UMEM_NUM / 2, &idx);
> +	if (!ASSERT_EQ(UMEM_NUM / 2, ret, "xsk_ring_prod__reserve"))
> +		return ret;
> +	if (!ASSERT_EQ(idx, 0, "fill idx != 0"))
> +		return -1;
> +
> +	for (i = 0; i < UMEM_NUM / 2; i++) {
> +		addr = (UMEM_NUM / 2 + i) * UMEM_FRAME_SIZE;
> +		printf("%p: rx_desc[%d] -> %lx\n", xsk, i, addr);
> +		*xsk_ring_prod__fill_addr(&xsk->fill, i) = addr;
> +	}
> +	xsk_ring_prod__submit(&xsk->fill, ret);
> +
> +	return 0;
> +}
> +

[ ... ]

> +void test_xdp_metadata(void)
> +{
> +	struct xdp_metadata2 *bpf_obj2 = NULL;
> +	struct xdp_metadata *bpf_obj = NULL;
> +	struct bpf_program *new_prog, *prog;
> +	struct nstoken *tok = NULL;
> +	__u32 queue_id = QUEUE_ID;
> +	struct bpf_map *prog_arr;
> +	struct xsk tx_xsk = {};
> +	struct xsk rx_xsk = {};
> +	__u32 val, key = 0;
> +	int retries = 10;
> +	int rx_ifindex;
> +	int sock_fd;
> +	int ret;
> +
> +	/* Setup new networking namespace, with a veth pair. */
> +
> +	SYS("ip netns add xdp_metadata");
> +	tok = open_netns("xdp_metadata");
> +	SYS("ip link add numtxqueues 1 numrxqueues 1 " TX_NAME
> +	    " type veth peer " RX_NAME " numtxqueues 1 numrxqueues 1");
> +	SYS("ip link set dev " TX_NAME " address 00:00:00:00:00:01");
> +	SYS("ip link set dev " RX_NAME " address 00:00:00:00:00:02");
> +	SYS("ip link set dev " TX_NAME " up");
> +	SYS("ip link set dev " RX_NAME " up");
> +	SYS("ip addr add " TX_ADDR "/" PREFIX_LEN " dev " TX_NAME);
> +	SYS("ip addr add " RX_ADDR "/" PREFIX_LEN " dev " RX_NAME);
> +
> +	rx_ifindex = if_nametoindex(RX_NAME);
> +
> +	/* Setup separate AF_XDP for TX and RX interfaces. */
> +
> +	ret = open_xsk(TX_NAME, &tx_xsk);
> +	if (!ASSERT_OK(ret, "open_xsk(TX_NAME)"))
> +		goto out;
> +
> +	ret = open_xsk(RX_NAME, &rx_xsk);
> +	if (!ASSERT_OK(ret, "open_xsk(RX_NAME)"))
> +		goto out;
> +
> +	bpf_obj = xdp_metadata__open();
> +	if (!ASSERT_OK_PTR(bpf_obj, "open skeleton"))
> +		goto out;
> +
> +	prog = bpf_object__find_program_by_name(bpf_obj->obj, "rx");
> +	bpf_program__set_ifindex(prog, rx_ifindex);
> +	bpf_program__set_flags(prog, BPF_F_XDP_DEV_BOUND_ONLY);
> +
> +	if (!ASSERT_OK(xdp_metadata__load(bpf_obj), "load skeleton"))
> +		goto out;
> +
> +	/* Make sure we can't add dev-bound programs to prog maps. */
> +	prog_arr = bpf_object__find_map_by_name(bpf_obj->obj, "prog_arr");
> +	if (!ASSERT_OK_PTR(prog_arr, "no prog_arr map"))
> +		goto out;
> +
> +	val = bpf_program__fd(prog);
> +	if (!ASSERT_ERR(bpf_map__update_elem(prog_arr, &key, sizeof(key),
> +					     &val, sizeof(val), BPF_ANY),
> +			"update prog_arr"))
> +		goto out;
> +
> +	/* Attach BPF program to RX interface. */
> +
> +	ret = bpf_xdp_attach(rx_ifindex,
> +			     bpf_program__fd(bpf_obj->progs.rx),
> +			     XDP_FLAGS, NULL);
> +	if (!ASSERT_GE(ret, 0, "bpf_xdp_attach"))
> +		goto out;
> +
> +	sock_fd = xsk_socket__fd(rx_xsk.socket);
> +	ret = bpf_map_update_elem(bpf_map__fd(bpf_obj->maps.xsk), &queue_id, &sock_fd, 0);
> +	if (!ASSERT_GE(ret, 0, "bpf_map_update_elem"))
> +		goto out;
> +
> +	/* Send packet destined to RX AF_XDP socket. */
> +	if (!ASSERT_GE(generate_packet(&tx_xsk, AF_XDP_CONSUMER_PORT), 0,
> +		       "generate AF_XDP_CONSUMER_PORT"))
> +		goto out;
> +
> +	/* Verify AF_XDP RX packet has proper metadata. */
> +	if (!ASSERT_GE(verify_xsk_metadata(&rx_xsk), 0,
> +		       "verify_xsk_metadata"))
> +		goto out;
> +
> +	complete_tx(&tx_xsk);
> +
> +	/* Make sure freplace correctly picks up original bound device
> +	 * and doesn't crash.
> +	 */
> +
> +	bpf_obj2 = xdp_metadata2__open();
> +	if (!ASSERT_OK_PTR(bpf_obj2, "open skeleton"))
> +		goto out;
> +
> +	new_prog = bpf_object__find_program_by_name(bpf_obj2->obj, "freplace_rx");
> +	bpf_program__set_attach_target(new_prog, bpf_program__fd(prog), "rx");
> +
> +	if (!ASSERT_OK(xdp_metadata2__load(bpf_obj2), "load freplace skeleton"))
> +		goto out;
> +
> +	if (!ASSERT_OK(xdp_metadata2__attach(bpf_obj2), "attach freplace"))
> +		goto out;
> +
> +	/* Send packet to trigger . */
> +	if (!ASSERT_GE(generate_packet(&tx_xsk, AF_XDP_CONSUMER_PORT), 0,
> +		       "generate freplace packet"))
> +		goto out;
> +
> +	while (!retries--) {
> +		if (bpf_obj2->bss->called)
> +			break;
> +		usleep(10);
> +	}
> +	ASSERT_GT(bpf_obj2->bss->called, 0, "not called");
> +
> +out:
> +	close_xsk(&rx_xsk);
> +	close_xsk(&tx_xsk);
> +	if (bpf_obj2)

nit. no need to test NULL.  xdp_metadata2__destroy() can handle it.

> +		xdp_metadata2__destroy(bpf_obj2);
> +	if (bpf_obj)

Same here.

> +		xdp_metadata__destroy(bpf_obj);
> +	system("ip netns del xdp_metadata");

didn't know netns can be deleted before close_netns(tok).  Can you double check?

> +	if (tok)
> +		close_netns(tok);
> +}



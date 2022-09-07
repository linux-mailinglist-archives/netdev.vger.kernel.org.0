Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8174A5B0C98
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiIGSis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiIGSip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:38:45 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF48EC0BF5;
        Wed,  7 Sep 2022 11:38:43 -0700 (PDT)
Message-ID: <c76121f4-911e-81c4-fbc9-104da70cfb66@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662575922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmAxea9/TDFfc8Au2zTCVnI7otvws4IKDaIpcDZh23I=;
        b=Vzkztui0F/zasUsIecQ4NJ7iN7CyGROE3ozX/ZpHtYuK8wsVCVRlQpGN68Wjr/Lpo2Ss0d
        KQTCaQqK/0LV7/q//NMzQnk/u3qbTTyA6QsX1sidkavESi+3KNy01PPwnte9foe1Zs+8FO
        D4X3Wr2arT+4fRGiJEBrgMz8XKg3le8=
Date:   Wed, 7 Sep 2022 11:38:29 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2 bpf-next 3/3] selftests/bpf: Ensure cgroup/connect{4,6}
 programs can bind unpriv ICMP ping
Content-Language: en-US
To:     YiFei Zhu <zhuyifei@google.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <cover.1662507638.git.zhuyifei@google.com>
 <892e0898c1255f980da13b0c7cc77cd5642edd36.1662507638.git.zhuyifei@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <892e0898c1255f980da13b0c7cc77cd5642edd36.1662507638.git.zhuyifei@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/6/22 4:48 PM, YiFei Zhu wrote:
> +void test_connect_ping(void)
> +{
> +	struct connect_ping *obj;
nit.  Rename it so skel.  All other tests use variable name 'skel' 
instead of 'obj'.

> +	int cgroup_fd;
> +
> +	if (!ASSERT_OK(unshare(CLONE_NEWNET | CLONE_NEWNS), "unshare"))
> +		return;
> +
> +	/* overmount sysfs, and making original sysfs private so overmount
> +	 * does not propagate to other mntns.
> +	 */
> +	if (!ASSERT_OK(mount("none", "/sys", NULL, MS_PRIVATE, NULL),
> +		       "remount-private-sys"))
> +		return;
> +	if (!ASSERT_OK(mount("sysfs", "/sys", "sysfs", 0, NULL),
> +		       "mount-sys"))
> +		return;
> +	if (!ASSERT_OK(mount("bpffs", "/sys/fs/bpf", "bpf", 0, NULL),
> +		       "mount-bpf"))
> +		goto clean_mount;
> +
> +	if (!ASSERT_OK(system("ip link set dev lo up"), "lo-up"))
> +		goto clean_mount;
> +	if (!ASSERT_OK(system("ip addr add 1.1.1.1 dev lo"), "lo-addr-v4"))
> +		goto clean_mount;
> +	if (!ASSERT_OK(system("ip -6 addr add 2001:db8::1 dev lo"), "lo-addr-v6"))
> +		goto clean_mount;
> +	if (write_sysctl("/proc/sys/net/ipv4/ping_group_range", "0 0"))
> +		goto clean_mount;
> +
> +	cgroup_fd = test__join_cgroup("/connect_ping");
> +	if (!ASSERT_GE(cgroup_fd, 0, "cg-create"))
> +		goto clean_mount;
> +
> +	obj = connect_ping__open_and_load();
> +	if (!ASSERT_OK_PTR(obj, "skel-load"))
> +		goto close_cgroup;
> +	obj->links.connect_v4_prog =
> +		bpf_program__attach_cgroup(obj->progs.connect_v4_prog, cgroup_fd);
> +	if (!ASSERT_OK_PTR(obj->links.connect_v4_prog, "cg-attach-v4"))
> +		goto close_cgroup;connect_ping__destroy() is also needed in this error path.

> +	obj->links.connect_v6_prog =
> +		bpf_program__attach_cgroup(obj->progs.connect_v6_prog, cgroup_fd);
> +	if (!ASSERT_OK_PTR(obj->links.connect_v6_prog, "cg-attach-v6"))
> +		goto close_cgroup;
Same here.

Others lgtm.  Thanks for refactoring the write_sysctl().


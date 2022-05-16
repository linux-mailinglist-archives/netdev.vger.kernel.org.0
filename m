Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9F2528C31
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 19:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243544AbiEPRmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 13:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344348AbiEPRmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 13:42:03 -0400
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [83.166.143.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A283437035
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 10:42:01 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L26533HNRzMqH2x;
        Mon, 16 May 2022 19:41:59 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4L26526GWVzlhSM4;
        Mon, 16 May 2022 19:41:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652722919;
        bh=V9W8jv2t/4XyAGkTZKcPQealex71qHyChm/nzaAjHWY=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=A4UPWJrjdPacuZV9squnsJMUekuUlktmgQTrRCQweCr1s5ZMYrTd/LcbELfsof956
         WhjhxNy8V+cGkc4VZlg5IIELx/7VoQrI9WqinnaTZEnTRVKn2212/RCvfrzBC5hk+v
         kCliXoIXVkFPTYHDeiLGfyL8f86PX9u76yMchqbE=
Message-ID: <4806f5ed-41c0-f9f2-d7a1-2173c8494399@digikod.net>
Date:   Mon, 16 May 2022 19:41:58 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-13-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v5 12/15] seltests/landlock: rules overlapping test
In-Reply-To: <20220516152038.39594-13-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please fix these kind of subjects (selftests). I'd also like the subject 
description to (quickly) describe what is done (with a verb), to start 
with a capital (like a title), and to contain "network", something like 
this:
selftests/landlock: Add test for overlapping network rules

This is a good test though.


On 16/05/2022 17:20, Konstantin Meskhidze wrote:
> This patch adds overlapping rules for one port.
> First rule adds just bind() access right for a port.
> The second one adds both bind() and connect()
> access rights for the same port.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v3:
> * Add ruleset_overlap test.
> 
> Changes since v4:
> * Refactoring code with self->port, self->addr4 variables.
> 
> ---
>   tools/testing/selftests/landlock/net_test.c | 51 +++++++++++++++++++++
>   1 file changed, 51 insertions(+)
> 
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> index bf8e49466d1d..1d8c9dfdbd48 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -677,4 +677,55 @@ TEST_F_FORK(socket_test, connect_afunspec_with_restictions) {
>   	ASSERT_EQ(1, WIFEXITED(status));
>   	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>   }
> +
> +TEST_F_FORK(socket_test, ruleset_overlap) {

Please run clang-format-14 on all files (and all commits).

> +
> +	int sockfd;
> +
> +	struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	struct landlock_net_service_attr net_service_1 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +
> +		.port = self->port[0],
> +	};
> +
> +		struct landlock_net_service_attr net_service_2 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +
> +		.port = self->port[0],
> +	};
> +
> +	const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +					sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	/* Allows bind operations to the port[0] socket */

Please ends this kind of comments with a final dot (all files/commits).

> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				       &net_service_1, 0));
> +	/* Allows connect and bind operations to the port[0] socket */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				       &net_service_2, 0));
> +
> +	/* Enforces the ruleset. */
> +	enforce_ruleset(_metadata, ruleset_fd);
> +
> +	/* Creates a server socket */
> +	sockfd = create_socket(_metadata, false, false);
> +	ASSERT_LE(0, sockfd);
> +
> +	/* Binds the socket to address with port[0] */
> +	ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&self->addr4[0], sizeof(self->addr4[0])));
> +
> +	/* Makes connection to socket with port[0] */
> +	ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&self->addr4[0],

Can you please get rid of this (struct sockaddr *) type casting please 
(without compiler warning)?

> +						   sizeof(self->addr4[0])));

Here, you can enforce a new ruleset with net_service_1 and check that 
bind() is still allowed but not connect().

> +
> +	/* Closes socket */
> +	ASSERT_EQ(0, close(sockfd));
> +}
> +
>   TEST_HARNESS_MAIN
> --
> 2.25.1
> 

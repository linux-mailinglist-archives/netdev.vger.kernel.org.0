Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976BF5AE21D
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238779AbiIFIKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238987AbiIFIKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:10:07 -0400
Received: from smtp-1909.mail.infomaniak.ch (smtp-1909.mail.infomaniak.ch [IPv6:2001:1600:3:17::1909])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D286F402F2
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:09:44 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MMJ2Z69FYzMqfXP;
        Tue,  6 Sep 2022 10:09:42 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MMJ2Z0tw3zMv9M6;
        Tue,  6 Sep 2022 10:09:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1662451782;
        bh=FktcKn0xci6C3IbZ6IUzdGphgetuY8cF6f/vIVA6DS4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ggRtY3ZLemWpH4HA6nP2CRgkusP5oNcS/nI19xGE9Iox7SXvSKPA6wzKbrwaUOUZg
         X/6Wz3Dq9b27383iWklOt0Y+PfRSEjXgj+OKOzvspotAfiXUIVvrfju7JiTbdxNSrf
         bJZ8Z0gVpA0l+5xgbeg8UVacvQowIQp0mWGjarLs=
Message-ID: <25b7e8c8-1eba-1a8d-138b-988dabeeb2ae@digikod.net>
Date:   Tue, 6 Sep 2022 10:09:41 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 14/18] seltests/landlock: add rules overlapping test
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        hukeping@huawei.com, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-15-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220829170401.834298-15-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29/08/2022 19:03, Konstantin Meskhidze wrote:
> This patch adds overlapping rules for one port. First rule adds just
> bind() access right for a port. The second one adds both bind() and
> connect() access rights for the same port.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v6:
> * None.
> 
> Changes since v5:
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors code with self->port, self->addr4 variables.
> 
> Changes since v3:
> * Adds ruleset_overlap test.
> 
> ---
>   tools/testing/selftests/landlock/net_test.c | 89 +++++++++++++++++++++
>   1 file changed, 89 insertions(+)
> 
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> index 40aef7c683af..b3b38745f4eb 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -464,4 +464,93 @@ TEST_F(socket, connect_afunspec_with_restictions)
>   	ASSERT_EQ(1, WIFEXITED(status));
>   	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>   }
> +
> +TEST_F(socket, ruleset_overlap)
> +{
> +	int sockfd;
> +	int one = 1;
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
> +	struct landlock_net_service_attr net_service_2 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +
> +		.port = self->port[0],
> +	};
> +
> +	int ruleset_fd =
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	/* Allows bind operations to the port[0] socket. */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				       &net_service_1, 0));
> +	/* Allows connect and bind operations to the port[0] socket. */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				       &net_service_2, 0));
> +
> +	/* Enforces the ruleset. */
> +	enforce_ruleset(_metadata, ruleset_fd);
> +
> +	/* Creates a server socket. */
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +	/* Allows to reuse of local address. */
> +	ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one,
> +				sizeof(one)));
> +
> +	/* Binds the socket to address with port[0]. */
> +	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
> +
> +	/* Makes connection to socket with port[0]. */
> +	ASSERT_EQ(0, connect_variant(variant, sockfd, self, 0));
> +
> +	/* Closes socket. */
> +	ASSERT_EQ(0, close(sockfd));
> +
> +	/* Creates another ruleset layer. */
> +	ruleset_fd =
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	/*
> +	 * Allows bind operations to the port[0] socket in
> +	 * the new ruleset layer.
> +	 */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				       &net_service_1, 0));
> +
> +	/* Enforces the new ruleset. */
> +	enforce_ruleset(_metadata, ruleset_fd);
> +
> +	/* Creates a server socket. */
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +	/* Allows to reuse of local address. */
> +	ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one,
> +				sizeof(one)));
> +
> +	/* Binds the socket to address with port[0]. */
> +	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
> +
> +	/*
> +	 * Forbids to connect the socket to address with port[0],
> +	 * cause just one ruleset layer has connect() access rule.

s/cause/because/ (everywhere)

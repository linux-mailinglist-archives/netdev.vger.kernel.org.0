Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999D95AE210
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbiIFIKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiIFIKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:10:20 -0400
Received: from smtp-190b.mail.infomaniak.ch (smtp-190b.mail.infomaniak.ch [185.125.25.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C121A46D92
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:09:54 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MMJ2n1LhRzMqjRR;
        Tue,  6 Sep 2022 10:09:53 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MMJ2m46ZwzMv9M1;
        Tue,  6 Sep 2022 10:09:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1662451793;
        bh=C4f3LEAWeOXiACdvoXpCHFzUVJOAPr7+6+mZ+g2CXoY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fPR+rGa5Q9VztYBNl2IRNojwLBr6NDC+IWtlBPYuOaWc/JiH/JVhZlzh+46mdCzOD
         Pn2EgudqPMPhg6ec4j9KPwysIf3pH1Jpdl/CMVnk3VSKWwHi2HJ2akOodcOnSguGUA
         QqW+piYFV/PXuFunB5o5qAjq9OhIMOTdrkTZYwUQ=
Message-ID: <d91e3fcc-2320-e98c-7d54-458b749c87a8@digikod.net>
Date:   Tue, 6 Sep 2022 10:09:51 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 16/18] seltests/landlock: add invalid input data test
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        hukeping@huawei.com, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-17-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220829170401.834298-17-konstantin.meskhidze@huawei.com>
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


On 29/08/2022 19:03, Konstantin Meskhidze wrote:
> This patch adds rules with invalid user space supplied data:
>      - out of range ruleset attribute;
>      - unhandled allowed access;
>      - zero port value;
>      - zero access value;
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v6:
> * Adds invalid ruleset attribute test.
> 
> Changes since v5:
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors code with self->port variable.
> 
> Changes since v3:
> * Adds inval test.
> 
> ---
>   tools/testing/selftests/landlock/net_test.c | 66 ++++++++++++++++++++-
>   1 file changed, 65 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> index a93224d1521b..067ba45f58a5 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -26,9 +26,12 @@
> 
>   #define IP_ADDRESS "127.0.0.1"
> 
> -/* Number pending connections queue to be hold */
> +/* Number pending connections queue to be hold. */

Patch of a previous patch?


>   #define BACKLOG 10
> 
> +/* Invalid attribute, out of landlock network access range. */
> +#define LANDLOCK_INVAL_ATTR 7
> +
>   FIXTURE(socket)
>   {
>   	uint port[MAX_SOCKET_NUM];
> @@ -719,4 +722,65 @@ TEST_F(socket, ruleset_expanding)
>   	/* Closes socket 1. */
>   	ASSERT_EQ(0, close(sockfd_1));
>   }
> +
> +TEST_F(socket, inval)
> +{
> +	struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP
> +	};
> +	struct landlock_ruleset_attr ruleset_attr_inval = {
> +		.handled_access_net = LANDLOCK_INVAL_ATTR

Please add a test similar to TEST_F_FORK(layout1, 
file_and_dir_access_rights) instead of explicitly defining and only 
testing LANDLOCK_INVAL_ATTR.


> +	};
> +	struct landlock_net_service_attr net_service_1 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		.port = self->port[0],
> +	};
> +	struct landlock_net_service_attr net_service_2 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +		.port = 0,
> +	};
> +	struct landlock_net_service_attr net_service_3 = {
> +		.allowed_access = 0,
> +		.port = self->port[1],
> +	};
> +	struct landlock_net_service_attr net_service_4 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +		.port = self->port[2],
> +	};
> +
> +	/* Checks invalid ruleset attribute. */
> +	const int ruleset_fd_inv = landlock_create_ruleset(
> +		&ruleset_attr_inval, sizeof(ruleset_attr_inval), 0);
> +	ASSERT_EQ(-1, ruleset_fd_inv);
> +	ASSERT_EQ(EINVAL, errno);
> +
> +	/* Gets ruleset. */
> +	const int ruleset_fd =
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	/* Checks unhandled allowed_access. */
> +	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +					&net_service_1, 0));
> +	ASSERT_EQ(EINVAL, errno);
> +
> +	/* Checks zero port value. */
> +	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +					&net_service_2, 0));
> +	ASSERT_EQ(EINVAL, errno);
> +
> +	/* Checks zero access value. */
> +	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +					&net_service_3, 0));
> +	ASSERT_EQ(ENOMSG, errno);
> +
> +	/* Adds with legitimate values. */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				       &net_service_4, 0));
> +
> +	/* Enforces the ruleset. */
> +	enforce_ruleset(_metadata, ruleset_fd);
> +	ASSERT_EQ(0, close(ruleset_fd));
> +}
>   TEST_HARNESS_MAIN
> --
> 2.25.1
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B265AE200
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbiIFIKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238751AbiIFIJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:09:59 -0400
Received: from smtp-8fac.mail.infomaniak.ch (smtp-8fac.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B498ADF41
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:09:33 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MMJ2N4CJCzMptVm;
        Tue,  6 Sep 2022 10:09:32 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4MMJ2M6GZRz14X;
        Tue,  6 Sep 2022 10:09:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1662451772;
        bh=fag0Vd7x/EMxq/c2fhbhP5izUxqUxAhqG33jBJ+1/7o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Tc7sI6A8DbE2d1wxIWIWgIPhyPOWrmB5PfZlmdc5eYdnE4J2JCPJmgMWAlcAV1epA
         IEgU3wkObiBd2cVmg4DbjHSCGOnBWuy6gNLy8FXCsd+kBvLILoC6FlKYmep5xTGaiQ
         MiFg4nv0Js7Ywa2RZ21sINTBil656uGIOSlVHfwE=
Message-ID: <707210e7-eaee-1b56-25fc-a50530fe5c12@digikod.net>
Date:   Tue, 6 Sep 2022 10:09:31 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 13/18] seltests/landlock: add AF_UNSPEC family test
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        hukeping@huawei.com, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-14-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220829170401.834298-14-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29/08/2022 19:03, Konstantin Meskhidze wrote:
> Adds two selftests for connect() action with AF_UNSPEC family flag.
> The one is with no landlock restrictions allows to disconnect already
> connected socket with connect(..., AF_UNSPEC, ...):
>      - connect_afunspec_no_restictions;

Typo: "restrictions" (everywhere)


> The second one refuses landlocked process to disconnect already
> connected socket:
>      - connect_afunspec_with_restictions;
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
> * Adds bind() hook check for with AF_UNSPEC family.
> 
> Changes since v3:
> * Adds connect_afunspec_no_restictions test.
> * Adds connect_afunspec_with_restictions test.
> 
> ---
>   tools/testing/selftests/landlock/net_test.c | 113 ++++++++++++++++++++
>   1 file changed, 113 insertions(+)
> 
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> index 9c3d1e425439..40aef7c683af 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -351,4 +351,117 @@ TEST_F(socket, connect_with_restrictions)
>   	ASSERT_EQ(1, WIFEXITED(status));
>   	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>   }
> +
> +TEST_F(socket, connect_afunspec_no_restictions)
> +{
> +	int sockfd;
> +	pid_t child;
> +	int status;
> +
> +	/* Creates a server socket 1. */
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +
> +	/* Binds the socket 1 to address with port[0]. */
> +	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
> +
> +	/* Makes connection to the socket with port[0]. */
> +	ASSERT_EQ(0, connect_variant(variant, sockfd, self, 0));
> +
> +	child = fork();
> +	ASSERT_LE(0, child);
> +	if (child == 0) {
> +		struct sockaddr addr_unspec = { .sa_family = AF_UNSPEC };

You can constify several variable like this one (in all tests).


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A1B5EECA8
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 06:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbiI2EJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 00:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbiI2EJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 00:09:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51BB36795
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 21:09:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCF5F61F6F
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 04:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25761C433D6;
        Thu, 29 Sep 2022 04:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664424593;
        bh=8CtWmZ8PMp1v83N6HKX7XrZCehlPqdQBQ3BDuNMUd5g=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=f78hy4ZNIsgP28RJmuyiwdSzlKwKLlGty3asokyQ6PAbY/olWYNjQQYIcC4uYHnPh
         II0rNhaRW8RBgqqzAN65u87+JYOeexvKSNP2i1ghUPlLxlA5PHwq0RdSpMZmR0lJuc
         nmbnKAUNWrf6QSn0Hzt63VCuvayz4u6AkCyrYpF0aZGfSqugZhtKgY9Gh+GZPR8cK9
         1FA1egfYn/U7jGbbcMaU4v//1/doDwhQKdMRndZxTfcRftLm6O/ZU115MbeDWVcgL7
         2uAPmIWFSQdxkozO04PxeHsZmbZG6LeqDL8sCU0AZSAdv++Lj3v0ZKdy5X8HpIZk3P
         iuD1oO06KqZMQ==
Message-ID: <5daece37-2c57-d2ea-be23-23825b022742@kernel.org>
Date:   Wed, 28 Sep 2022 22:09:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCHv2 iproute2-next] rtnetlink: add new function
 rtnl_echo_talk()
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20220929032320.455310-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220929032320.455310-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/22 8:23 PM, Hangbin Liu wrote:
> @@ -2609,23 +2604,9 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
>  	}
>  
>  	if (echo_request)
> -		ret = rtnl_talk(&rth, &req.n, &answer);
> +		return rtnl_echo_talk(&rth, &req.n, json, print_addrinfo);
>  	else
> -		ret = rtnl_talk(&rth, &req.n, NULL);
> -
> -	if (ret < 0)
> -		return -2;
> -
> -	if (echo_request) {
> -		new_json_obj(json);
> -		open_json_object(NULL);
> -		print_addrinfo(answer, stdout);
> -		close_json_object();
> -		delete_json_obj();
> -		free(answer);
> -	}
> -
> -	return 0;
> +		return rtnl_talk(&rth, &req.n, NULL);

you have a few occurrences of this and I can't fix it by editing the
patch. It should be this:

	if (echo_request)
		return rtnl_echo_talk(...)

	return rtnl_talk(...)

i.e, no 'else' and the second return is only indented once.


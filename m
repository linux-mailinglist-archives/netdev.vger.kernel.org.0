Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB3E5E6D08
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiIVUbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiIVUbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:31:49 -0400
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A153109527
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:31:48 -0700 (PDT)
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
        by mail.parknet.co.jp (Postfix) with ESMTPSA id 758A72003FB8;
        Fri, 23 Sep 2022 05:31:46 +0900 (JST)
Received: from devron.myhome.or.jp (foobar@devron.myhome.or.jp [192.168.0.3])
        by ibmpc.myhome.or.jp (8.17.1.9/8.17.1.9/Debian-1) with ESMTPS id 28MKVjWK090175
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 05:31:46 +0900
Received: from devron.myhome.or.jp (foobar@localhost [127.0.0.1])
        by devron.myhome.or.jp (8.17.1.9/8.17.1.9/Debian-1) with ESMTPS id 28MKVjZO236857
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 05:31:45 +0900
Received: (from hirofumi@localhost)
        by devron.myhome.or.jp (8.17.1.9/8.17.1.9/Submit) id 28MKVifF236856;
        Fri, 23 Sep 2022 05:31:44 +0900
From:   OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] Fix segv on "-r" option if unknown rpc service
In-Reply-To: <20220922120105.7a200fd2@hermes.local> (Stephen Hemminger's
        message of "Thu, 22 Sep 2022 12:01:05 -0700")
References: <87tu55q48x.fsf@mail.parknet.co.jp>
        <20220922120105.7a200fd2@hermes.local>
Date:   Fri, 23 Sep 2022 05:31:44 +0900
Message-ID: <87sfkjcfrj.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/29.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> writes:

> On Sun, 18 Sep 2022 02:50:54 +0900
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
>
>> +		} else {
>> +			const char fmt[] = "%s%u";
>> +			char *buf = NULL;
>> +			int len = snprintf(buf, 0, fmt, prog,
>> +					   rhead->rpcb_map.r_prog);
>> +			len++;
>> +			buf = malloc(len);
>> +			snprintf(buf, len, fmt, prog, rhead->rpcb_map.r_prog);
>> +			c->name = buf;
>>  		}
>
> Thanks for finding the bug but this could be improved.
> This seems like the hard way to do this.
> You are reinventing asprintf().

Right, if this project is assuming the extension is available.

> Would this work instead.

Thanks.

> diff --git a/misc/ss.c b/misc/ss.c
> index ff985cd8cae9..9d3d0bd84df3 100644
> --- a/misc/ss.c
> +++ b/misc/ss.c
> @@ -1596,6 +1596,10 @@ static void init_service_resolver(void)
>                 if (rpc) {
>                         strncat(prog, rpc->r_name, 128 - strlen(prog));
>                         c->name = strdup(prog);
> +               } else if (asprintf(&c->name, "%s%u",
> +                                   prog, rhead->rpcb_map.r_prog) < 0) {
> +                       fprintf(stderr, "ss: asprintf failed to allocate buffer\n");
> +                       abort();
>                 }
>  
>                 c->next = rlist;

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

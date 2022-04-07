Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8C24F7D53
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiDGK62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244674AbiDGK6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:58:16 -0400
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316CA78FE8;
        Thu,  7 Apr 2022 03:56:14 -0700 (PDT)
Received: from [IPV6:2a01:e35:39f2:1220:bf15:70c6:368e:e3ba] (unknown [IPv6:2a01:e35:39f2:1220:bf15:70c6:368e:e3ba])
        by smtp1-g21.free.fr (Postfix) with ESMTPS id D1822B0057F;
        Thu,  7 Apr 2022 12:56:05 +0200 (CEST)
Message-ID: <8a87957e-4d33-9351-ae74-243441cb03cd@opteya.com>
Date:   Thu, 7 Apr 2022 12:56:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] af_unix: Escape abstract unix socket address
Content-Language: fr-FR
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
References: <20220406102213.2020784-1-ydroneaud@opteya.com>
 <20220406145941.728b4cb5@hermes.local>
From:   Yann Droneaud <ydroneaud@opteya.com>
Organization: OPTEYA
In-Reply-To: <20220406145941.728b4cb5@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Le 06/04/2022 à 23:59, Stephen Hemminger a écrit :
> On Wed,  6 Apr 2022 12:22:13 +0200
> Yann Droneaud <ydroneaud@opteya.com> wrote:
>
>> Abstract unix socket address are bytes sequences up to
>> 108 bytes (UNIX_PATH_MAX == sizeof(struct sockaddr_un) -
>> offsetof(struct sockaddr_un, sun_path)).
>>
>> As with any random string of bytes, printing them in
>> /proc/net/unix should be done with caution to prevent
>> misbehavior.
>>
>> It would have been great to use seq_escape_mem() to escape
>> the control characters in a reversible way.
>>
>> Unfortunately userspace might expect that NUL bytes are
>> replaced with '@' characters as it's done currently.
>>
>> So this patch implements the following scheme: any control
>> characters, including NUL, in the abstract unix socket
>> addresses is replaced by '@' characters.
>>
>> Sadly, with such non reversible escape scheme, abstract
>> addresses such as "\0\0", "\0\a", "\0\b", "\0\t", etc.
>> will have the same representation: "@@".
>>
>> But will prevent "cat /proc/net/unix" from messing with
>> terminal, and will prevent "\n" in abstract address from
>> messing with parsing the list of Unix sockets.
>>
>> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
>> ---
>>   net/unix/af_unix.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>> index e71a312faa1e..8021efd92301 100644
>> --- a/net/unix/af_unix.c
>> +++ b/net/unix/af_unix.c
>> @@ -3340,7 +3340,8 @@ static int unix_seq_show(struct seq_file *seq, void *v)
>>   				i++;
>>   			}
>>   			for ( ; i < len; i++)
>> -				seq_putc(seq, u->addr->name->sun_path[i] ?:
>> +				seq_putc(seq, !iscntrl(u->addr->name->sun_path[i]) ?
>> +					 u->addr->name->sun_path[i] :
>>   					 '@');
>>   		}
>>   		unix_state_unlock(s);
> Unfortunately, you will break userspace ABI with this.

It's a wanted side effect.

Consider the following program


#include <stddef.h>
#include <stdio.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

#define ADDRESS "\0\n0000000000000000: 00000003 00000000 00000000 0001 03 1234567890 /bin/true"

int main(void)
{
	static const struct sockaddr_un un = {
		.sun_family = AF_UNIX,
		.sun_path = ADDRESS,
	};
	int s;

	s = socket(AF_UNIX, SOCK_STREAM, 0);
	if (s < 0) {
		perror("socket");
		return 1;
	}

	if (bind(s, (const struct sockaddr *)&un, offsetof(struct sockaddr_un,sun_path) + sizeof(ADDRESS) - 1) < 0) {
		perror("bind");
		return 1;
	}

	while (1)
		pause();

	return 0;
}


This confuses
- cat /proc/net/unix
- netstat -x

Only ss -xl doesn't take /bin/true as a Unix socket (but ss output is broken because it doesn't escape \n in unix addresses)


Regards.

-- 
Yann Droneaud
OPTEYA


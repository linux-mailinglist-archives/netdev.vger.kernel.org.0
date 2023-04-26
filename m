Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC706EF9A6
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbjDZRxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjDZRxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:53:11 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887CB61AB;
        Wed, 26 Apr 2023 10:53:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 63E196017E;
        Wed, 26 Apr 2023 19:53:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682531583; bh=ix3yZfX9qAGGSCgGBfddgoc3bJRhu281Z1JgEWmvIZQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=E8C8VEInskBWRChFkZ4Vz+TJY2EBceb+E1AZgguFg42BRujK74/XKdmuKbD/fp54A
         uLEGaQh13KalmQ4k54AvDMC0MKmpbhdaumc6TTNlUSpmfkg1Q0rtDuAgmbtZmI0RZP
         J8Mnan9OaMw7b4ejwDeHcPVkSrmQBSZMP6Zk8oGGjGetdiYCF4SukB4vmQy66vWvF9
         KHQJd48ou/TTwAP5CDQBo8UabFO8OSu4gRiZW4V60+coPrLfDzVMt0B8joYwBWM5WT
         NzPoJ347+fNK31vc/4RzDVFOgW3Uv/Erx5ByOfqnV+w06xFx3/HbQPFZi2lM5E9YvH
         RvO2Ys3jVnm6A==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nsmIIG9q5Hnn; Wed, 26 Apr 2023 19:53:01 +0200 (CEST)
Received: from [192.168.1.4] (unknown [94.250.188.177])
        by domac.alu.hr (Postfix) with ESMTPSA id ADFF16017C;
        Wed, 26 Apr 2023 19:52:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682531581; bh=ix3yZfX9qAGGSCgGBfddgoc3bJRhu281Z1JgEWmvIZQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lqhmVaopu7TtdZ3rBlQR6ffhkNbIlIDzcOoATDn25HmXEsTsAZAHPqvrpZ+cKHgxy
         RSijHFO+c2PfdtBBF1VP+GlB0wiqb+rDOrnURqUjp6Hm/ydagtzjejuGL2+QiWP+gf
         IvN83FycjwQkDe0ZijHG1LI2rfscvT6LuEQI+Xj1jacqwzzTjwkZFCUjC6i90OZKsT
         DsnaGc+Jl3hoMceEFxhrnBhVRzhI8lvr0EhEePwoJxoxtBY5gpgdCl46S1CExHkdUh
         7RBqOwXnzr/I8cGZKg3BZ8F/UGb9pt51LgoYrWVYd5hph9y1nXh5LOmTi8h7O0Huv0
         O8xfhiU3h092w==
Message-ID: <e6f97703-58a2-befb-d09b-cee7e946a8a4@alu.unizg.hr>
Date:   Wed, 26 Apr 2023 19:52:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 1/1] wifi: mac80211: fortify the spinlock against
 deadlock by interrupt
To:     Johannes Berg <johannes@sipsolutions.net>,
        Leon Romanovsky <leon@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Alexander Wetzel <alexander@wetzel-home.de>
References: <20230425164005.25272-1-mirsad.todorovac@alu.unizg.hr>
 <20230426064145.GE27649@unreal>
 <074cf5ed-c39d-1c16-12e7-4b14bbe0cac4@alu.unizg.hr>
 <d1e8fff25b49f8ee8d3e38f7b072d6e1911759bb.camel@sipsolutions.net>
Content-Language: en-US, hr
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <d1e8fff25b49f8ee8d3e38f7b072d6e1911759bb.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26. 04. 2023. 17:05, Johannes Berg wrote:
> On Wed, 2023-04-26 at 16:02 +0200, Mirsad Todorovac wrote:
>>
>> That's awesome! Just to ask, do I need to send the PATCH v5 with the
>> Reviewed-by: tag, or it goes automatically?
>>
> 
> Patchwork will be pick it up automatically.
> 
> johannes

That's awesome, thank you for the update.

Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

"I see something approaching fast ... Will it be friends with me?"


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0F7304371
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 17:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbhAZQLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 11:11:10 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22912 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404480AbhAZQLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 11:11:02 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10QFk1pI020268;
        Tue, 26 Jan 2021 08:10:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=yFGofJEnthj2Gms6IZORm039en+ZqCMXM7a0xzlHRt8=;
 b=Wh6UO9xK9dBIjCB2BlCAi59r9jSuKDKhzqsbNlqkgyNY9/VrRVCqVOp0dHaq8G7OCWcT
 Pxs4qokwcn/Dtsja1O3lGrVCg+y/9i5/zTxFzB/UfCwN2gmGi9QIT68ae5+GT3qy1ztu
 L4dzjT9wqn8QXPf9yEO3jCkXSjSWamMV93i0dl0/oxE8tCeZUVziZoFKDf9g6sDxw15k
 mul1Y0QyKJy5IFHZtZfj0pM72yd6TBFpPyKwiz5jQcC7FARGiJt9yxwuaDkCMx0M69ED
 V0+ddcLBOJPfob/ioMl43YZucglFhZu2BTBdY+csUBhk0FXyF6RcbmF451MgrTNiyamO XQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1u8sp6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Jan 2021 08:10:17 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 26 Jan
 2021 08:10:16 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 26 Jan 2021 08:10:16 -0800
Received: from [10.193.38.82] (unknown [10.193.38.82])
        by maili.marvell.com (Postfix) with ESMTP id 471BD3F704B;
        Tue, 26 Jan 2021 08:10:15 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH net-next 2/2] samples: pktgen: new append mode
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210122150517.7650-1-irusskikh@marvell.com>
 <20210122150517.7650-3-irusskikh@marvell.com>
 <20210126140954.34989297@carbon>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <3016f908-7c9f-6ed5-714e-686def88aae5@marvell.com>
Date:   Tue, 26 Jan 2021 17:10:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <20210126140954.34989297@carbon>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-26_08:2021-01-26,2021-01-26 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper,

Thanks for reviewing this.

>> DELAY may now be explicitly specified via common parameter -w
> 
> What are you actually using this for?

Basically, for the second patch.

When running multidev pktgen (using that -a option) with large amount of clones and
bursts (-c and -b) I saw that some of the devices got stuck - i.e. traffic was not
distributed evenly I think the reason of that is `next_to_run` selection logic, which
always takes first pkt_dev in a list.
Adding even a small delay param makes it consider next_tx data and creates a uniform
distribution between devices.

May be it makes sense to reconsider `next_to_run` selection logic, but I was
concentrating on scripts, so thats it.

> Notice there is also an option called "ratep" which can be used for
> setting the packet rate per sec.  In the pktgen.c code, it will use the
> "delay" variable.

Yes, I think in current form it makes no much harm if user knows what he wants.

>> +  -w : ($DELAY)     Tx Delay value (us)
>> +  -a : ($APPENDCFG) Script will not reset generator's state, but will
> append its config
> 
> You called it $APPENDCFG, but code use $APPEND.

Thanks, will fix.

>>  
>> -[[ $EUID -eq 0 ]] && trap 'pg_ctrl "reset"' EXIT
>> +[ -z "$APPEND" ] && [ "$EUID" -eq 0 ] && trap '[ -z "$APPEND" ] &&
> pg_ctrl "reset"' EXIT
> 
> This looks confusing and wrong (I think).
> (e.g. is the second '[ -z "$APPEND" ] && ...' needed).
> 
> In functions.sh we don't need to "compress" the lines that much. I
> prefer readability in this file.  (Cc Daniel T. Lee as he added this
> line).  Maybe we can make it more human readable:

Agree on style, could be fixed.

> if [[ -z "$APPEND" ]]; then
> 	if [[ $EUID -eq 0 ]]; then
> 		# Cleanup pktgen setup on exit
> 		trap 'pg_ctrl "reset"' EXIT
> 	fi
> fi
> 
> I'm a little confused how the "trap" got added into 'functions.sh', as
> my original intend was that function.sh should only provide helper
> functions and not have a side-effect. (But I can see I acked the
> change).

I also don't like much the fact trap is being placed in that file.
Here I've placed one extra "-z $APPEND" exactly because of that.

In append mode of usage we do `source functions.sh` directly from bash.
That causes a side effect that trap is installed in root shell.
I can't check if thats APPEND mode or not at this moment. Thats why I do check APPEND
inside of the trap.

An alternative would be moving trap (or a function installing the trap) into each of
the scripts. That was the old behavior BTW.


>> +if [ -z "$APPEND" ]; then
>> +
>>  # start_run
>>  echo "Running... ctrl^C to stop" >&2
>>  pg_ctrl "start"
>> @@ -85,3 +87,7 @@ echo "Done" >&2
>>  # Print results
>>  echo "Result device: $DEV"
>>  cat /proc/net/pktgen/$DEV
>> +
>> +else
>> +echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
>> +fi
> 
> Hmm, could we indent lines for readability?
> (Same in other files)

Agreed, will fix.

Thanks,
  Igor

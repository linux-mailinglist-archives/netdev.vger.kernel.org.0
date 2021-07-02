Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639EA3BA238
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 16:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhGBOed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 10:34:33 -0400
Received: from www259.your-server.de ([188.40.28.39]:56536 "EHLO
        www259.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbhGBOed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 10:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=waldheinz.de; s=default1911; h=MIME-Version:Content-Type:In-Reply-To:
        References:Subject:Cc:To:From:Message-ID:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=FXc7LzDoxI7AGLPQwAClDkV+Z2ijm7twtsV2j4xH0c4=; b=M1Glb+7z44cQSbPGmPbAFuykNz
        FARWANMSx1rhetywpRuVbfMrsnagVvUt/njXjiS9OQemUjpr7oG3bbYaphYYf4Y6hU3acPzTE/VDb
        SYf9ZxjNky93oHtWnY1XgS6lI+cwWiCJx39aO+s9BMQ9WZT/auzkQKmJwba9zXN8iKYUbg5Qq2KU9
        g9w9jCiS5gm1iEEE2c2wt7spMczkbT2c4EDbufxLa5M1a6Rl+27H6BhVzxImoMQeRHlAwLzPEiIhm
        g9Gw6Kz902LlP8h4ItQiFxU1/+kNHvKoDb3nBfu2MaoL8tk9FGXgTs1eTgAlU1EcurssU8V0AwVM/
        BbH85vNg==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www259.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <mt@waldheinz.de>)
        id 1lzKCr-00052i-EY; Fri, 02 Jul 2021 16:31:49 +0200
Received: from [192.168.0.32] (helo=mail.your-server.de)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256)
        (Exim 4.92)
        (envelope-from <mt@waldheinz.de>)
        id 1lzKCr-000Spp-3h; Fri, 02 Jul 2021 16:31:49 +0200
Received: from ip4d1584d2.dynamic.kabel-deutschland.de
 (ip4d1584d2.dynamic.kabel-deutschland.de [77.21.132.210]) by
 mail.your-server.de (Horde Framework) with HTTPS; Fri, 02 Jul 2021 16:31:49
 +0200
Date:   Fri, 02 Jul 2021 16:31:48 +0200
Message-ID: <20210702163148.Horde.OPbmfqdhfEMDjt3Q2A7ru7c@mail.your-server.de>
From:   Matthias Treydte <mt@waldheinz.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [regression] UDP recv data corruption
References: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de>
 <38ddc0e8-ba27-279b-8b76-4062db6719c6@gmail.com>
 <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
 <39df657bee89e56c704782e0c061383d276d2f7c.camel@redhat.com>
In-Reply-To: <39df657bee89e56c704782e0c061383d276d2f7c.camel@redhat.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Authenticated-Sender: mt@waldheinz.de
X-Virus-Scanned: Clear (ClamAV 0.103.2/26219/Fri Jul  2 13:06:52 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Quoting Paolo Abeni <pabeni@redhat.com>:

Finally got your mail, seems it was delayed, sorry.

> - check, if possibly, how exactly the pkts are corrupted. Wrong size?
> bad csum? what else?
>
> - ideally a short pcap trace comprising the problematic packets would
> be great!

While trying to produce something I came up with an interesting  
observation which seems to indicate that the problem lies in the  
combination of GRO and fragmented UDP packets:

Tuning the sending side (for my testing purposes also FFMpeg) to send  
UDP packets of 1316 bytes tops makes the problem go away in the  
receiver. The value must be an exact multiple of 188 (the MPEG TS  
frame size) to cause FFMpeg not to send fragmented packets at all.

Using this we were able to do the following on our normal desktop machines:

The sending side uses an command like this:

ffmpeg \
   -stream_loop -1 \
   -re -i "$video" \
   -c:v copy -c:a copy \
   -f mpegts "udp://239.12.23.0:1935"

and the receiver (in our case using Linux 5.12.14) "mpv  
udp://239.12.23.0:1935" to see the stream. For our test $video was  
just some h264 encoded MKV I had laying around. The receiver sees  
compression artifacts and the "Packet corrupt" messages in the  
console. Now there are two ways to improve this situation:

1) The receiver uses ethtool to disable GRO
2) The sender changes the URL to be "udp://239.12.23.0:1935?pkt_size=1316"

At this point I assume there are better ways to reproduce this using  
netcat or the like. But being a video guy, well, here we are. ;-)

My knowledge about the inner workings of Linux' IP stack are lacking,  
but because tcpdump "sees" packets before they are reassembled and the  
problem seems to exist only with packets that were fragmented and  
reassembled (as they are presented to libav), I have the feeling that  
a pcap file would not be that helpful with this, right?


Regards,
-Matthias


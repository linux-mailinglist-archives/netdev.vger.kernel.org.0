Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D35B56CD
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 22:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfIQUUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 16:20:31 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:57198 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbfIQUUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 16:20:31 -0400
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x8HKHDOm011461;
        Tue, 17 Sep 2019 21:20:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=to : from : subject :
 message-id : date : mime-version : content-type :
 content-transfer-encoding; s=jan2016.eng;
 bh=oeAoulvqTAVPglxM6IypRvtGXITm1w0Sz42FBD3ci1s=;
 b=nOIK2GCiiH2oMGtq0ei07SLcx82KzFuwnjZ+G9i1rEBuQoLUQHZenHWZspo84mXR5zVq
 RXdlRbu+turAYGfzytvVn1+WAtdhOrgAi/xt9n5akm80ivYr+u6Q0cnL4CdEgPBY23+q
 +NDLNwt0xqepquDe4LvxqxHymDOCIhlR6Jzt+DTeaS6rZtJS5hUpliorQjKi7V09v5lg
 NZqhEUhSAzJjMcja7TWqweJ39ZJhE8H9TJYNOWPoP7CLOFJynK1pfXEip9FGIyM8iEpF
 0KoVMCJZ5VdPkaxTabS/Ob6OaWJQRWODitYmbTnuECBqIfjwQaaGcl2MFVCi8vIFBbOq 5g== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 2v0tehpd6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 21:20:26 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x8HKIV7Z014462;
        Tue, 17 Sep 2019 16:20:25 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2v0uhw6eh3-1;
        Tue, 17 Sep 2019 16:20:25 -0400
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id E989832ABE;
        Tue, 17 Sep 2019 20:20:21 +0000 (GMT)
To:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
From:   Josh Hunt <johunt@akamai.com>
Subject: udp sendmsg ENOBUFS clarification
Message-ID: <ce01f024-268d-a44e-8093-91be97f1e8b0@akamai.com>
Date:   Tue, 17 Sep 2019 13:20:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-17_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=663
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909170190
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-17_11:2019-09-17,2019-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=749 priorityscore=1501
 bulkscore=0 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1909170190
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was running some tests recently with the udpgso_bench_tx benchmark in 
selftests and noticed that in some configurations it reported sending 
more than line rate! Looking into it more I found that I was overflowing 
the qdisc queue and so it was sending back NET_XMIT_DROP however this 
error did not propagate back up to the application and so it assumed 
whatever it sent was done successfully. That's when I learned about 
IP_RECVERR and saw that the benchmark isn't using that socket option.

That's all fairly straightforward, but what I was hoping to get 
clarification on is where is the line drawn on when or when not to send 
ENOBUFS back to the application if IP_RECVERR is *not* set? My guess 
based on going through the code is that as long as the packet leaves the 
stack (in this case sent to the qdisc) that's where we stop reporting 
ENOBUFS back to the application, but can someone confirm?

For example, we sanitize the error in udp_send_skb():
send:
         err = ip_send_skb(sock_net(sk), skb);
         if (err) {
                 if (err == -ENOBUFS && !inet->recverr) {
                         UDP_INC_STATS(sock_net(sk),
                                       UDP_MIB_SNDBUFERRORS, is_udplite);
                         err = 0;
                 }
         } else


but in udp_sendmsg() we don't:

         if (err == -ENOBUFS || test_bit(SOCK_NOSPACE, 
&sk->sk_socket->flags)) {
                 UDP_INC_STATS(sock_net(sk),
                               UDP_MIB_SNDBUFERRORS, is_udplite);
         }
         return err;

In the case above it looks like we may only get ENOBUFS for allocation 
failures inside of the stack in udp_sendmsg() and so that's why we 
propagate the error back up to the application?

Somewhat related, while I was trying to find answer to the above I came 
across this thread https://patchwork.ozlabs.org/patch/32857/ It looks 
like the man send() man page still only says the following about -ENOBUFS:

  "The output queue for a network interface was full.
   This generally indicates that the interface has stopped sending,
   but may be caused by transient congestion.
   (Normally, this does not occur in Linux. Packets are just silently
   dropped when a device queue overflows.) "

but as Eric points out that's not true when IP_RECVERR is set on the 
socket. Was there an attempt to update the man page to reflect this, but 
it was rejected? I couldn't find any discussion on this.

Thanks
Josh

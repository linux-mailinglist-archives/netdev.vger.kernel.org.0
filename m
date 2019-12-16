Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0E412017E
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLPJvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:51:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726992AbfLPJvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:51:21 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBG9lNKJ041449
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 04:51:20 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wwe35uwey-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 04:51:19 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <wenjia@linux.ibm.com>;
        Mon, 16 Dec 2019 09:51:17 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 16 Dec 2019 09:51:14 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBG9pDPI58982488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Dec 2019 09:51:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DD84AE055;
        Mon, 16 Dec 2019 09:51:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58C64AE056;
        Mon, 16 Dec 2019 09:51:13 +0000 (GMT)
Received: from [9.152.224.25] (unknown [9.152.224.25])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Dec 2019 09:51:13 +0000 (GMT)
Subject: Re: s390 EAGAIN on send{msg,to}()/recvmsg() on small MTU and big
 packet size
To:     Petr Vorel <pvorel@suse.cz>, linux-s390@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190923152558.GA31182@dell5510>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
Date:   Mon, 16 Dec 2019 10:51:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20190923152558.GA31182@dell5510>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19121609-0028-0000-0000-000003C90A39
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121609-0029-0000-0000-0000248C4D6D
Message-Id: <ab8289e5-547c-5375-5d0f-e9a363005db1@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_02:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 clxscore=1011 mlxlogscore=944 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160088
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,

This is not really a bug on s390 but on general linux. A big IP packet is fragmented into small packets according to the MTU size.  Each small packet consumes an amount of system memory, which are recorded in ‘skb->truesize’. And the sum of the space all of the small packets need is limited by ‘2 * sk->sk_sndbuf’ (which you can find in '__ip_append_data' function in net/ipv4/ip_output.c), that is inherited from the system default set during socket initialization. The problem on s390 is that ‘skb->truesize’ is got by aligning the size of the data buffer to the L1 cache line (using SKB_DATA_ALIGN), which on s390 and only on s390 is 256 bytes, while on other processors less than or equal to 128 bytes. So the sum on s390 is much easier to exceed the limit, that the big packet can not be sent successfully.
Because of the big cache line size on s390, the maximum size of the packet is limited in between 53816 and 64960, if the MTU is set to between 484 and 588.
However, this problem not only occurs on s390, but also on some other processor e.g. x86. If the MTU is set to less than 340, an IP packet with the theoretical maximum size (65507 bytes) likewise can not be sent successfully.

Best,              

Wenjia

On 23/09/2019 17:25, Petr Vorel wrote:
> Hi,
>
> I've found a bug on s390 on small MTU combined with big packet size, using ping
> (of course both within valid ranges, e.g. MTU 552 and packet size 61245).
>
> Below is full reproducer on netns.
>
> I tested it on vanilla: v5.3-rc8 and v4.16.
> I reproduced it on current iputils master which uses sendto()/recvmsg() and on
> older version which uses sendmsg()/recvmsg().
>
> As I'm not aware of any s390 specific socket code in kernel I suspect big endian or something else.
>
> This bug was find with LTP/if-mtu-change.sh.
>
> REPRODUCER:
> LTP_NS="ip netns exec ltp_ns"
> ip net add ltp_ns
> ip li add name ltp_ns_veth1 type veth peer name ltp_ns_veth2
> ip li set dev ltp_ns_veth1 netns ltp_ns
> $LTP_NS ip li set lo up
>
> ip xfrm policy flush
> ip xfrm state flush
> ip link set ltp_ns_veth2 down
> ip route flush dev ltp_ns_veth2
> ip addr flush dev ltp_ns_veth2
> ip link set ltp_ns_veth2 up
> ip addr add 10.0.0.2/24 dev ltp_ns_veth2
>
> $LTP_NS ip xfrm policy flush
> $LTP_NS ip xfrm state flush
> $LTP_NS ip link set ltp_ns_veth1 down
> $LTP_NS ip route flush dev ltp_ns_veth1
> $LTP_NS ip addr flush dev ltp_ns_veth1
> $LTP_NS ip link set ltp_ns_veth1 up
> $LTP_NS ip addr add 10.0.0.1/24 dev ltp_ns_veth1
>
> i=552; ip link set dev ltp_ns_veth2 mtu $i; $LTP_NS ip link set dev ltp_ns_veth1 mtu $i # it's enough to set just one of them
>
> ping -I 10.0.0.2 -c 1 10.0.0.1 -s 61245 # fail
> ping -I 10.0.0.2 -c 1 10.0.0.1 -s 61244 # ok
>
> FAIL (iputils-s20121221 from package, using sendmsg())
> ioctl(1, TCGETS, {B38400 opost isig icanon echo ...}) = 0
> ioctl(1, TIOCGWINSZ, {ws_row=74, ws_col=273, ws_xpixel=1911, ws_ypixel=1050}) = 0
> sendmsg(3, {msg_name(16)={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("10.0.0.1")}, msg_iov(1)=[{"\10\0\253_\241\373\0\1\0\0\0\0]wf\330\0\0\0\0\0\6\375\201\20\21\22\23\24\25\26\27"..., 61253}], msg_controllen=0, msg_flags=0}, 0) = 61253
> setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={10, 0}}, NULL) = 0
> recvmsg(3, 0x3fff887b588, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3fff887b588, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3fff887b588, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3fff887b588, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3fff887b588, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3fff887b588, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3fff887b588, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3fff887b588, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3fff887b588, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3fff887b588, 0)            = -1 EINTR (Interrupted system call)
> --- SIGALRM {si_signo=SIGALRM, si_code=SI_KERNEL} ---
> sigreturn({mask=[]})                    = -1 EINTR (Interrupted system call)
>
> OK (iputils-s20121221 from package, using sendmsg())
> ioctl(1, TCGETS, {B38400 opost isig icanon echo ...}) = 0
> ioctl(1, TIOCGWINSZ, {ws_row=74, ws_col=273, ws_xpixel=1911, ws_ypixel=1050}) = 0
> sendmsg(3, {msg_name(16)={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("10.0.0.1")}, msg_iov(1)=[{"\10\0\3u\242\266\0\1\0\0\0\0]wgd\0\0\0\0\0\6\340%\20\21\22\23\24\25\26\27"..., 61252}], msg_controllen=0, msg_flags=0}, 0) = 61252
> setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={10, 0}}, NULL) = 0
> recvmsg(3, {msg_name(16)={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("10.0.0.1")}, msg_iov(1)=[{"E\0\357X2\277\0\0@\1D\343\n\0\0\1\n\0\0\2\0\0\vu\242\266\0\1\0\0\0\0"..., 61380}], msg_controllen=32, [{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=0x1d /*
> SCM_??? */, ...}], msg_flags=0}, 0) = 61272
> write(1, "61252 bytes from 10.0.0.1: icmp_"..., 5961252 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.442 ms
> ) = 59
>
> FAIL (current iputils master, using sendto())
> ioctl(1, TCGETS, {B38400 opost isig icanon echo ...}) = 0
> ioctl(1, TIOCGWINSZ, {ws_row=74, ws_col=273, ws_xpixel=1911, ws_ypixel=1050}) = 0
> sendto(3, "\10\0\2=\313\315\0\1\0\0\0\0]vH;\0\0\0\0\0\7\233o\20\21\22\23\24\25\26\27"..., 61253, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("10.0.0.1")}, 16) = 61253
> setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={10, 0}}, NULL) = 0
> recvmsg(3, 0x3ffe7e7b388, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3ffe7e7b388, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3ffe7e7b388, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3ffe7e7b388, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3ffe7e7b388, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3ffe7e7b388, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3ffe7e7b388, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3ffe7e7b388, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3ffe7e7b388, 0)            = -1 EAGAIN (Resource temporarily unavailable)
> recvmsg(3, 0x3ffe7e7b388, 0)            = -1 EINTR (Interrupted system call)
> --- SIGALRM {si_signo=SIGALRM, si_code=SI_KERNEL} ---
> sigreturn({mask=[]})                    = -1 EINTR (Interrupted system call)
>
> OK (current iputils master, using sendto())
> ioctl(1, TCGETS, {B38400 opost isig icanon echo ...}) = 0
> ioctl(1, TIOCGWINSZ, {ws_row=74, ws_col=273, ws_xpixel=1911, ws_ypixel=1050}) = 0
> sendto(3, "\10\0y\4\313\365\0\1\0\0\0\0]vHw\0\0\0\0\0\4`G\20\21\22\23\24\25\26\27"..., 61252, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("10.0.0.1")}, 16) = 61252
> setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={10, 0}}, NULL) = 0
> recvmsg(3, {msg_name(16)={sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("10.0.0.1")}, msg_iov(1)=[{"E\0\357Xc$\0\0@\1\24~\n\0\0\1\n\0\0\2\0\0\201\4\313\365\0\1\0\0\0\0"..., 61380}], msg_controllen=32, [{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=0x1d /*
> SCM_??? */, ...}], msg_flags=0}, 0) = 61272
> write(1, "61252 bytes from 10.0.0.1: icmp_"..., 59) = 59
>
> Kind regards,
> Petr


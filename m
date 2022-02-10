Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE914B030C
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiBJCIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:08:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbiBJCII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:08:08 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0956CE77;
        Wed,  9 Feb 2022 18:06:01 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JvKp30f4Gz67bj2;
        Thu, 10 Feb 2022 10:05:15 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Thu, 10 Feb 2022 03:05:58 +0100
Message-ID: <fcbeec21-d6ab-caa2-4eb0-09d712536c2d@huawei.com>
Date:   Thu, 10 Feb 2022 05:05:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 1/2] landlock: TCP network hooks implementation
Content-Language: ru
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-2-konstantin.meskhidze@huawei.com>
 <CA+FuTSf4EjgjBCCOiu-PHJcTMia41UkTh8QJ0+qdxL_J8445EA@mail.gmail.com>
 <0934a27a-d167-87ea-97d2-b3ac952832ff@huawei.com>
 <CA+FuTSc8ZAeaHWVYf-zmn6i5QLJysYGJppAEfb7tRbtho7_DKA@mail.gmail.com>
 <d84ed5b3-837a-811a-6947-e857ceba3f83@huawei.com>
 <CA+FuTSeVhLdeXokyG4x__HGJyNOwsSicLOb4NKJA-gNp59S5uA@mail.gmail.com>
 <0d33f7cd-6846-5e7e-62b9-fbd0b28ecea9@digikod.net>
 <91885a8f-b787-62ff-1abb-700641f7c2cb@huawei.com>
 <CA+FuTScaoby-=xRKf_Dz3koSYHqrMN0cauCg4jMmy_nDxwPADA@mail.gmail.com>
 <CA+FuTSc6BfWKu1taQr7wPoQ4VJg3Au1PH-rbTa71-srLzARL-A@mail.gmail.com>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <CA+FuTSc6BfWKu1taQr7wPoQ4VJg3Au1PH-rbTa71-srLzARL-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/7/2022 7:17 PM, Willem de Bruijn пишет:
>>>    If bind() function has already been restricted so the following
>>> listen() function is automatically banned. I agree with Mickaёl about
>>> the usecase here. Why do we need new-bound socket with restricted listening?
>>
>> The intended use-case is for a privileged process to open a connection
>> (i.e., bound and connected socket) and pass that to a restricted
>> process. The intent is for that process to only be allowed to
>> communicate over this pre-established channel.
>>
>> In practice, it is able to disconnect (while staying bound) and
>> elevate its privileges to that of a listening server:
>>
>> static void child_process(int fd)
>> {
>>          struct sockaddr addr = { .sa_family = AF_UNSPEC };
>>          int client_fd;
>>
>>          if (listen(fd, 1) == 0)
>>                  error(1, 0, "listen succeeded while connected");
>>
>>          if (connect(fd, &addr, sizeof(addr)))
>>                  error(1, errno, "disconnect");
>>
>>          if (listen(fd, 1))
>>                  error(1, errno, "listen");
>>
>>          client_fd = accept(fd, NULL, NULL);
>>          if (client_fd == -1)
>>                  error(1, errno, "accept");
>>
>>          if (close(client_fd))
>>                  error(1, errno, "close client");
>> }
>>
>> int main(int argc, char **argv)
>> {
>>          struct sockaddr_in6 addr = { 0 };
>>          pid_t pid;
>>          int fd;
>>
>>          fd = socket(PF_INET6, SOCK_STREAM, 0);
>>          if (fd == -1)
>>                  error(1, errno, "socket");
>>
>>          addr.sin6_family = AF_INET6;
>>          addr.sin6_addr = in6addr_loopback;
>>
>>          addr.sin6_port = htons(8001);
>>          if (bind(fd, (void *)&addr, sizeof(addr)))
>>                  error(1, errno, "bind");
>>
>>          addr.sin6_port = htons(8000);
>>          if (connect(fd, (void *)&addr, sizeof(addr)))
>>                  error(1, errno, "connect");
>>
>>          pid = fork();
>>          if (pid == -1)
>>                  error(1, errno, "fork");
>>
>>          if (pid)
>>                  wait(NULL);
>>          else
>>                  child_process(fd);
>>
>>          if (close(fd))
>>                  error(1, errno, "close");
>>
>>          return 0;
>> }
>>
>> It's fine to not address this case in this patch series directly, of
>> course. But we should be aware of the AF_UNSPEC loophole.
> 
> I did just notice that with autobind (i.e., without the explicit call
> to bind), the socket gets a different local port after listen. So
> internally a bind call may be made, which may or may not be correctly
> handled by the current landlock implementation already:

   Thanks again. I will check it out.
> 
> +static void show_local_port(int fd)
> +{
> +       char addr_str[INET6_ADDRSTRLEN];
> +       struct sockaddr_in6 addr = { 0 };
> +       socklen_t alen;
> +
> +       alen = sizeof(addr);
> +       if (getsockname(fd, (void *)&addr, &alen))
> +               error(1, errno, "getsockname");
> +
> +       if (addr.sin6_family != AF_INET6)
> +               error(1, 0, "getsockname: family");
> +
> +       if (!inet_ntop(AF_INET6, &addr.sin6_addr, addr_str, sizeof(addr_str)))
> +               error(1, errno, "inet_ntop");
> +       fprintf(stderr, "server: %s:%hu\n", addr_str, ntohs(addr.sin6_port));
> +
> +}
> +
> @@ -23,6 +42,8 @@ static void child_process(int fd)
>          if (connect(fd, &addr, sizeof(addr)))
>                  error(1, errno, "disconnect");
> 
> +       show_local_port(fd);
> +
>          if (listen(fd, 1))
>                  error(1, errno, "listen");
> 
> +       show_local_port(fd);
> +
> 
> @@ -47,10 +68,6 @@ int main(int argc, char **argv)
>          addr.sin6_family = AF_INET6;
>          addr.sin6_addr = in6addr_loopback;
> 
> -       addr.sin6_port = htons(8001);
> -       if (bind(fd, (void *)&addr, sizeof(addr)))
> -               error(1, errno, "bind");
> -
>          addr.sin6_port = htons(8000);
>          if (connect(fd, (void *)&addr, sizeof(addr)))
>                  error(1, errno, "connect");
> .

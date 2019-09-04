Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A80AA896C
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfIDPRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:17:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:60542 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729888AbfIDPRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 11:17:01 -0400
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5X1U-0003n7-VI; Wed, 04 Sep 2019 17:16:41 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5X1U-00057d-LP; Wed, 04 Sep 2019 17:16:40 +0200
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
To:     Alexei Starovoitov <ast@fb.com>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
 <ed8796f5-eaea-c87d-ddd9-9d624059e5ee@iogearbox.net>
 <20190829173034.up5g74onaekp53zd@ast-mbp.dhcp.thefacebook.com>
 <59ac111e-7ce7-5e00-32c9-9b55482fe701@6wind.com>
 <46df2c36-4276-33c0-626b-c51e77b3a04f@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5e36a193-8ad9-77e7-e2ff-429fb521a79c@iogearbox.net>
Date:   Wed, 4 Sep 2019 17:16:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <46df2c36-4276-33c0-626b-c51e77b3a04f@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25562/Wed Sep  4 10:23:03 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/19 3:39 AM, Alexei Starovoitov wrote:
> On 8/30/19 8:19 AM, Nicolas Dichtel wrote:
>> Le 29/08/2019 à 19:30, Alexei Starovoitov a écrit :
>> [snip]
>>> These are the links that showing that k8 can delegates caps.
>>> Are you saying that you know of folks who specifically
>>> delegate cap_sys_admin and cap_net_admin _only_ to a container to run bpf in there?
>>>
>> Yes, we need cap_sys_admin only to load bpf:
>> tc filter add dev eth0 ingress matchall action bpf obj ./tc_test_kern.o sec test
>>
>> I'm not sure to understand why cap_net_admin is not enough to run the previous
>> command (ie why load is forbidden).
> 
> because bpf syscall prog_load command requires cap_sys_admin in
> the current implementation.
> 
>> I want to avoid sys_admin, thus cap_bpf will be ok. But we need to manage the
>> backward compatibility.
> 
> re: backward compatibility...
> do you know of any case where task is running under userid=nobody
> with cap_sys_admin and cap_net_admin in order to do bpf ?
> 
> If not then what is the concern about compatibility?

Finally managed to find some cycles to pull up a k8s cluster. Looks like it would
break deployments with the patches as-is right away; meaning, any constellation
where BPF is used inside the pod.

With CAP_BPF patches applied on bpf-next:

# kubectl apply -f ./cilium.yaml
[...]
# kubectl get pods --all-namespaces -o wide
NAMESPACE     NAME                               READY   STATUS              RESTARTS   AGE     IP              NODE     NOMINATED NODE   READINESS GATES
kube-system   cilium-cz9qs                       0/1     CrashLoopBackOff    4          2m36s   192.168.1.125   apoc     <none>           <none>
kube-system   cilium-operator-6c7c6c788b-xcm9d   0/1     Pending             0          2m36s   <none>          <none>   <none>           <none>
kube-system   coredns-5c98db65d4-6nhpg           0/1     ContainerCreating   0          4m12s   <none>          apoc     <none>           <none>
kube-system   coredns-5c98db65d4-l5b94           0/1     ContainerCreating   0          4m12s   <none>          apoc     <none>           <none>
kube-system   etcd-apoc                          1/1     Running             0          3m26s   192.168.1.125   apoc     <none>           <none>
kube-system   kube-apiserver-apoc                1/1     Running             0          3m32s   192.168.1.125   apoc     <none>           <none>
kube-system   kube-controller-manager-apoc       1/1     Running             0          3m18s   192.168.1.125   apoc     <none>           <none>
kube-system   kube-proxy-jj9kz                   1/1     Running             0          4m12s   192.168.1.125   apoc     <none>           <none>
kube-system   kube-scheduler-apoc                1/1     Running             0          3m26s   192.168.1.125   apoc     <none>           <none>
# kubectl -n kube-system logs --timestamps cilium-cz9qs
[...]
2019-09-04T14:11:46.399478585Z level=info msg="Cilium 1.6.90 ba0ed147b 2019-09-03T21:20:30+02:00 go version go1.12.8 linux/amd64" subsys=daemon
2019-09-04T14:11:46.410564471Z level=info msg="cilium-envoy  version: b7a919ebdca3d3bbc6aae51357e78e9c603450ae/1.11.1/Modified/RELEASE/BoringSSL" subsys=daemon
2019-09-04T14:11:46.446983926Z level=info msg="clang (7.0.0) and kernel (5.3.0) versions: OK!" subsys=daemon
[...]
2019-09-04T14:11:47.27988188Z level=info msg="Mounting BPF filesystem at /run/cilium/bpffs" subsys=bpf
2019-09-04T14:11:47.279904256Z level=info msg="Detected mounted BPF filesystem at /run/cilium/bpffs" subsys=bpf
2019-09-04T14:11:47.280205098Z level=info msg="Valid label prefix configuration:" subsys=labels-filter
2019-09-04T14:11:47.280214528Z level=info msg=" - :io.kubernetes.pod.namespace" subsys=labels-filter
2019-09-04T14:11:47.28021738Z level=info msg=" - :io.cilium.k8s.namespace.labels" subsys=labels-filter
2019-09-04T14:11:47.280220836Z level=info msg=" - :app.kubernetes.io" subsys=labels-filter
2019-09-04T14:11:47.280223355Z level=info msg=" - !:io.kubernetes" subsys=labels-filter
2019-09-04T14:11:47.280225723Z level=info msg=" - !:kubernetes.io" subsys=labels-filter
2019-09-04T14:11:47.280228095Z level=info msg=" - !:.*beta.kubernetes.io" subsys=labels-filter
2019-09-04T14:11:47.280230409Z level=info msg=" - !:k8s.io" subsys=labels-filter
2019-09-04T14:11:47.280232699Z level=info msg=" - !:pod-template-generation" subsys=labels-filter
2019-09-04T14:11:47.280235569Z level=info msg=" - !:pod-template-hash" subsys=labels-filter
2019-09-04T14:11:47.28023792Z level=info msg=" - !:controller-revision-hash" subsys=labels-filter
2019-09-04T14:11:47.280240253Z level=info msg=" - !:annotation.*" subsys=labels-filter
2019-09-04T14:11:47.280242566Z level=info msg=" - !:etcd_node" subsys=labels-filter
2019-09-04T14:11:47.28026585Z level=info msg="Initializing daemon" subsys=daemon
2019-09-04T14:11:47.281344002Z level=info msg="Detected MTU 1500" subsys=mtu
2019-09-04T14:11:47.281771889Z level=error msg="Error while opening/creating BPF maps" error="Unable to create map /run/cilium/bpffs/tc/globals/cilium_lxc: operation not permitted" subsys=daemon
2019-09-04T14:11:47.28178666Z level=fatal msg="Error while creating daemon" error="Unable to create map /run/cilium/bpffs/tc/globals/cilium_lxc: operation not permitted" subsys=daemon

And /same/ deployment with reverted patches, hence no CAP_BPF gets it up and running again:

# kubectl get pods --all-namespaces -o wide
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE   IP              NODE     NOMINATED NODE   READINESS GATES
kube-system   cilium-cz9qs                       1/1     Running   13         50m   192.168.1.125   apoc     <none>           <none>
kube-system   cilium-operator-6c7c6c788b-xcm9d   0/1     Pending   0          50m   <none>          <none>   <none>           <none>
kube-system   coredns-5c98db65d4-6nhpg           1/1     Running   0          52m   10.217.0.91     apoc     <none>           <none>
kube-system   coredns-5c98db65d4-l5b94           1/1     Running   0          52m   10.217.0.225    apoc     <none>           <none>
kube-system   etcd-apoc                          1/1     Running   1          51m   192.168.1.125   apoc     <none>           <none>
kube-system   kube-apiserver-apoc                1/1     Running   1          51m   192.168.1.125   apoc     <none>           <none>
kube-system   kube-controller-manager-apoc       1/1     Running   1          51m   192.168.1.125   apoc     <none>           <none>
kube-system   kube-proxy-jj9kz                   1/1     Running   1          52m   192.168.1.125   apoc     <none>           <none>
kube-system   kube-scheduler-apoc                1/1     Running   1          51m   192.168.1.125   apoc     <none>           <none>

Thanks,
Daniel

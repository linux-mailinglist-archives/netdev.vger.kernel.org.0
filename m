Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F782191E7
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgGHU7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:59:51 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:37778 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbgGHU7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:59:51 -0400
X-Greylist: delayed 1324 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2020 16:59:49 EDT
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 068KXW8c005852;
        Wed, 8 Jul 2020 21:33:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 mime-version; s=jan2016.eng;
 bh=mO1wrjyV2OelH5OHTYA7XXlXVYLVkAVK9u1Dp65QdR8=;
 b=NyPhQkDn8QocS20oiq2lo+xvHQr+Fbvh7t9Gh8smmqhKB4p3OK+vZRxyyJC1moafh5dE
 xdoCf34m7+nICmvMr8x9YnnDAn6gRmjGzu41Rg+smv925L0W3dDEcUISmRlPuCP9BqNS
 +7V2NmIUcBFP5ANFdlKiuOpiBaqTZBsm6j/6pSrKwyeIpCgjj2EbrCCsHXdSVCDcAqZT
 3qRlJe78yRNvFPr50XgHLfaqSSzpPPE6ei92fYB+RFxJT7LEg9fxOXszH6vqzl0/PzV4
 g25jFQEWsDqXy+SL7IV7FGOWbVdzSHwzcO/5dNeX/EsDss0rEJjirbTCQcWP8Irf2zW3 HQ== 
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 325k1xs74d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 21:33:41 +0100
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 068K6dhp008309;
        Wed, 8 Jul 2020 16:33:40 -0400
Received: from email.msg.corp.akamai.com ([172.27.165.118])
        by prod-mail-ppoint4.akamai.com with ESMTP id 325k4w8y5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 16:33:40 -0400
Received: from ustx2ex-dag3mb5.msg.corp.akamai.com (172.27.165.129) by
 USTX2EX-DAG3MB4.msg.corp.akamai.com (172.27.165.128) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 8 Jul 2020 13:33:39 -0700
Received: from ustx2ex-dag3mb5.msg.corp.akamai.com ([172.27.165.129]) by
 ustx2ex-dag3mb5.msg.corp.akamai.com ([172.27.165.129]) with mapi id
 15.00.1497.006; Wed, 8 Jul 2020 16:33:39 -0400
From:   "Zhivich, Michael" <mzhivich@akamai.com>
To:     "Hunt, Joshua" <johunt@akamai.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
Thread-Topic: Packet gets stuck in NOLOCK pfifo_fast qdisc
Thread-Index: AQHWTxK75CELHL4wL0WHx+6+Dg4FAKjzJ9qAgABBHICAAKwPAIAAOwkAgACMfoCACVNtAA==
Date:   Wed, 8 Jul 2020 20:33:39 +0000
Message-ID: <9DDC4F99-3133-47F7-A107-E9E5F9E1ADD0@akamai.com>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com>
 <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com>
 <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
In-Reply-To: <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.19.47.76]
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
        micalg=sha256; boundary="B_3677070818_351846658"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_17:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007080119
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_17:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007080124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--B_3677070818_351846658
Content-type: text/plain;
	charset="UTF-8"
Content-transfer-encoding: 7bit

On 7/2/20, 2:08 PM, "Josh Hunt" <johunt@akamai.com> wrote:
>
> On 7/2/20 2:45 AM, Paolo Abeni wrote:
> > Hi all,
> > 
> > On Thu, 2020-07-02 at 08:14 +0200, Jonas Bonn wrote:
> >> Hi Cong,
> >>
> >> On 01/07/2020 21:58, Cong Wang wrote:
> >>> On Wed, Jul 1, 2020 at 9:05 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>> On Tue, Jun 30, 2020 at 2:08 PM Josh Hunt <johunt@akamai.com> wrote:
> >>>>> Do either of you know if there's been any development on a fix for this
> >>>>> issue? If not we can propose something.
> >>>>
> >>>> If you have a reproducer, I can look into this.
> >>>
> >>> Does the attached patch fix this bug completely?
> >>
> >> It's easier to comment if you inline the patch, but after taking a quick
> >> look it seems too simplistic.
> >>
> >> i)  Are you sure you haven't got the return values on qdisc_run reversed?
> > 
> > qdisc_run() returns true if it was able to acquire the seq lock. We
> > need to take special action in the opposite case, so Cong's patch LGTM
> > from a functional PoV.
> > 
> >> ii) There's a "bypass" path that skips the enqueue/dequeue operation if
> >> the queue is empty; that needs a similar treatment:  after releasing
> >> seqlock it needs to ensure that another packet hasn't been enqueued
> >> since it last checked.
> > 
> > That has been reverted with
> > commit 379349e9bc3b42b8b2f8f7a03f64a97623fff323
> > 
> > ---
> >> diff --git a/net/core/dev.c b/net/core/dev.c
> >> index 90b59fc50dc9..c7e48356132a 100644
> >> --- a/net/core/dev.c
> >> +++ b/net/core/dev.c
> >> @@ -3744,7 +3744,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
> >>
> >>   	if (q->flags & TCQ_F_NOLOCK) {
> >>   		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> >> -		qdisc_run(q);
> >> +		if (!qdisc_run(q) && rc == NET_XMIT_SUCCESS)
> >> +			__netif_schedule(q);
> > 
> > I fear the __netif_schedule() call may cause performance regression to
> > the point of making a revert of TCQ_F_NOLOCK preferable. I'll try to
> > collect some data.
>
> Initial results with Cong's patch look promising, so far no stalls. We 
> will let it run over the long weekend and report back on Tuesday.
>
> Paolo - I have concerns about possible performance regression with the 
> change as well. If you can gather some data that would be great. If 
> things look good with our low throughput test over the weekend we can 
> also try assessing performance next week.
>
> Josh

After running our reproducer over the long weekend, we've observed several more packets getting stuck.
The behavior is order of magnitude better *with* the patch (that is, only a few packets get stuck),
but the patch does not completely resolve the issue.

I have a nagging suspicion that the same race that we observed between consumer/producer threads can occur with
softirq processing in net_tx_action() as well (as triggered by __netif_schedule()), since both rely on the same semantics of qdisc_run().  
Unfortunately, in such a case, we cannot just punt to __netif_schedule() again.

Regards,
~ Michael

--B_3677070818_351846658
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIINnwYJKoZIhvcNAQcCoIINkDCCDYwCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0B
BwGgggt6MIIFOzCCBOGgAwIBAgITFwAFsq0YpJgVeLyblAAAAAWyrTAKBggqhkjOPQQDAjA8
MSEwHwYDVQQKExhBa2FtYWkgVGVjaG5vbG9naWVzIEluYy4xFzAVBgNVBAMTDkFrYW1haUNs
aWVudENBMB4XDTIwMDQyMjE5MjkwNFoXDTIxMDQxNzE5MjkwNFowbjEcMBoGA1UEChMTQWth
bWFpIFRlY2hub2xvZ2llczEXMBUGA1UECxMOQVVUTy1ib3MtbXBtemIxETAPBgNVBAMTCG16
aGl2aWNoMSIwIAYJKoZIhvcNAQkBFhNtemhpdmljaEBha2FtYWkuY29tMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEA85hjQdbJU0nEaTTqdWMg579D2wvMb8oAZ137qn6F0Yak
m2Qb4T0cCuQKM5oUYIFuyfSlnqhlvSnou8FEhbYc//0Ljic0eedA3WaIgTtRAOAA+qQBZrWN
qXzOt3362zZIqU7fbsLaHVpTBVMq1EiNjv2cCpKvQ1f5GllM494nH+vI6yX89YCB1uwXTjaC
fBBvB5aCqzfocAiYX+d0D4nP3IJRNBXx1wK5zujWqkoWRohH4L6WgSmgeKBAfiqC3uIBtkhh
sUGvSTrlA353GRHpqH3s2Ue2kvnWSFspp2fyfqAknwvdUDcIgmE/AQkgtMIsnllhTbh88M1b
UxYocv/fmwIDAQABo4ICwzCCAr8wCwYDVR0PBAQDAgWgMDMGA1UdJQQsMCoGCCsGAQUFBwMH
BggrBgEFBQcDAgYKKwYBBAGCNwoDBAYIKwYBBQUHAwQwMwYDVR0RBCwwKqAoBgorBgEEAYI3
FAIDoBoMGG16aGl2aWNoQGNvcnAuYWthbWFpLmNvbTAdBgNVHQ4EFgQU+lcC2GdBNGvDLr1v
LmhIiCy/0YwwHwYDVR0jBBgwFoAUk4erMWaQ2spNFgOM5MMPveYNLAwwegYDVR0fBHMwcTBv
oG2ga4YuaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNsaWVudENBLmNybIY5
aHR0cDovL2FrYW1haWNybC5kZncwMS5jb3JwLmFrYW1haS5jb20vQWthbWFpQ2xpZW50Q0Eu
Y3JsMIHCBggrBgEFBQcBAQSBtTCBsjA6BggrBgEFBQcwAoYuaHR0cDovL2FrYW1haWNybC5h
a2FtYWkuY29tL0FrYW1haUNsaWVudENBLmNydDBFBggrBgEFBQcwAoY5aHR0cDovL2FrYW1h
aWNybC5kZncwMS5jb3JwLmFrYW1haS5jb20vQWthbWFpQ2xpZW50Q0EuY3J0MC0GCCsGAQUF
BzABhiFodHRwOi8vYWthbWFpb2NzcC5ha2FtYWkuY29tL29jc3AwPAYJKwYBBAGCNxUHBC8w
LQYlKwYBBAGCNxUIgs7lOoe41C2BhYsHouMhhtIPgUmE5N8FgZD6FAIBZAIBGzBBBgkrBgEE
AYI3FQoENDAyMAoGCCsGAQUFBwMHMAoGCCsGAQUFBwMCMAwGCisGAQQBgjcKAwQwCgYIKwYB
BQUHAwQwRAYJKoZIhvcNAQkPBDcwNTAOBggqhkiG9w0DAgICAIAwDgYIKoZIhvcNAwQCAgCA
MAcGBSsOAwIHMAoGCCqGSIb3DQMHMAoGCCqGSM49BAMCA0gAMEUCIQDq8FxcUc1l8H94tebZ
wPgr2nFPgFNzPSA+/vITyCILAAIgQITrjM1LM8tNk9cK67MPFiEyOSI7cE4Mzooqkwzu4Ucw
ggRmMIIEC6ADAgECAhM+AAAACuqzGxBold1TAAAAAAAKMAoGCCqGSM49BAMCMD8xITAfBgNV
BAoTGEFrYW1haSBUZWNobm9sb2dpZXMgSW5jLjEaMBgGA1UEAxMRQWthbWFpQ29ycFJvb3Qt
RzEwHhcNMTUwNjA0MTQ0NjA3WhcNMjUwNjA0MTQ1NjA3WjA8MSEwHwYDVQQKExhBa2FtYWkg
VGVjaG5vbG9naWVzIEluYy4xFzAVBgNVBAMTDkFrYW1haUNsaWVudENBMFkwEwYHKoZIzj0C
AQYIKoZIzj0DAQcDQgAEpuPNNA/ZEjWEkhjgWrKAipOQ72FwxtH8l6tvtbIFC5IfpXFiAN5Y
B//ydeR3aM1Xk9l/JOQlbwOuOtNP7UgZoqOCAucwggLjMBAGCSsGAQQBgjcVAQQDAgEAMB0G
A1UdDgQWBBSTh6sxZpDayk0WA4zkww+95g0sDDCBsAYDVR0gBIGoMIGlMIGiBgsqAwSPTgEJ
CQgBATCBkjBYBggrBgEFBQcCAjBMHkoAQQBrAGEAbQBhAGkAIABDAGUAcgB0AGkAZgBpAGMA
YQB0AGUAIABQAHIAYQBjAHQAaQBjAGUAIABTAHQAYQB0AGUAbQBlAG4AdDA2BggrBgEFBQcC
ARYqaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNQUy5wZGYAMFUGA1UdJQRO
MEwGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYKKwYBBAGC
NwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMJMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsG
A1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFK0Bh+rcWa6xEzmVTQ9X
oCSGi3u9MIGABgNVHR8EeTB3MHWgc6BxhjFodHRwOi8vYWthbWFpY3JsLmFrYW1haS5jb20v
QWthbWFpQ29ycFJvb3QtRzEuY3JshjxodHRwOi8vYWthbWFpY3JsLmRmdzAxLmNvcnAuYWth
bWFpLmNvbS9Ba2FtYWlDb3JwUm9vdC1HMS5jcmwwgcgGCCsGAQUFBwEBBIG7MIG4MC0GCCsG
AQUFBzABhiFodHRwOi8vYWthbWFpb2NzcC5ha2FtYWkuY29tL29jc3AwPQYIKwYBBQUHMAKG
MWh0dHA6Ly9ha2FtYWljcmwuYWthbWFpLmNvbS9Ba2FtYWlDb3JwUm9vdC1HMS5jcnQwSAYI
KwYBBQUHMAKGPGh0dHA6Ly9ha2FtYWljcmwuZGZ3MDEuY29ycC5ha2FtYWkuY29tL0FrYW1h
aUNvcnBSb290LUcxLmNydDAKBggqhkjOPQQDAgNJADBGAiEAxb2BDEI5u7VpG4TgR0KbsktK
aQOiFL6T6KtkAx7D8xACIQDJXMn85cVLMHcRe3wdfR/6Nr0ofAejZ6IaKj34qkK5KzCCAc0w
ggFzoAMCAQICEBWwiAMHXDS7Q8DxTR/GKBEwCgYIKoZIzj0EAwIwPzEhMB8GA1UEChMYQWth
bWFpIFRlY2hub2xvZ2llcyBJbmMuMRowGAYDVQQDExFBa2FtYWlDb3JwUm9vdC1HMTAeFw0x
NTA1MDUxODA5MjBaFw00MDA1MDUxODE5MjBaMD8xITAfBgNVBAoTGEFrYW1haSBUZWNobm9s
b2dpZXMgSW5jLjEaMBgGA1UEAxMRQWthbWFpQ29ycFJvb3QtRzEwWTATBgcqhkjOPQIBBggq
hkjOPQMBBwNCAARlk5NoCPduAuWtjE9cFFfGYSzz6+kqS2Ys/LckQf2pPv6ZBFThRFEZhdbH
6JqzeS9Kdz/zOm3WPOOEa01s2l6Zo1EwTzALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB
/zAdBgNVHQ4EFgQUrQGH6txZrrETOZVND1egJIaLe70wEAYJKwYBBAGCNxUBBAMCAQAwCgYI
KoZIzj0EAwIDSAAwRQIgKY8PO2tJ89kGAIPZLEJXCa0fVRPBYoF9LGIEQGBDQjECIQDlbB4a
rnvZHK7HN0fpn72P1/DsFpmhjVXhJMmX3Ev4hTGCAekwggHlAgEBMFMwPDEhMB8GA1UEChMY
QWthbWFpIFRlY2hub2xvZ2llcyBJbmMuMRcwFQYDVQQDEw5Ba2FtYWlDbGllbnRDQQITFwAF
sq0YpJgVeLyblAAAAAWyrTANBglghkgBZQMEAgEFAKBpMC8GCSqGSIb3DQEJBDEiBCBXYyOs
svvLedPzG+Cgvqg5vJdBkdwejct2NXku3QCnvjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMDA3MDgyMDMzMzhaMA0GCSqGSIb3DQEBAQUABIIBAKIU/0Up
g7Wa1y1467TKSUEvU207mGRegu1bROl7tSaxcTzB6Cu28Uc1ZvByo95+p3LgfWz7qTSyhRzz
ZCcT3hUMCMnnC7Vo4BnEr/wJolfEYwOGdkJA5pAccT00t5vfr1cZ4vxSa85BOoG/4O4PG2H3
U1/TYxmoTSH3QjkKvDDwmgJkDLn9xWEOpjv5KedIqEUtpBZXqgafT9dAW1GzVzKBtjELsoWL
hEQ6DrGQG0EpkY1BwevF8wNvsF2bG9+XkQ27W3WaXZW75/KjsnwUKO1IQTZG6k842UsFJR9y
9ZmApDrxEtpx60LdrAGG8fHVwFzCVDhTdueuQtEU4/9+27E=

--B_3677070818_351846658--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185C113BC86
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 10:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgAOJhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 04:37:09 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:18550 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729467AbgAOJhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 04:37:09 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 68F1E41618;
        Wed, 15 Jan 2020 17:37:03 +0800 (CST)
Subject: Re: [PATCH net-next v2] net/mlx5e: Add mlx5e_flower_parse_meta
 support
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
References: <1578388566-27310-1-git-send-email-wenxu@ucloud.cn>
 <CAJ3xEMjmS=oo6xmep7seVUJ58NPpLQ_UKZH1qVWxf6w=sBBJgQ@mail.gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <03dcc568-b855-0a58-66e5-d4df0c8f202e@ucloud.cn>
Date:   Wed, 15 Jan 2020 17:37:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAJ3xEMjmS=oo6xmep7seVUJ58NPpLQ_UKZH1qVWxf6w=sBBJgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0tNS0tLS09KQk1KTUxZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6K006Hhw5Ajg4DjFLKT1MS0lW
        PhlPCh9VSlVKTkxCS0NKS0lPTExNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBTkJPTTcG
X-HM-Tid: 0a6fa890408c2086kuqy68f1e41618
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/15/2020 5:13 PM, Or Gerlitz wrote:
> On Tue, Jan 7, 2020 at 11:17 AM <wenxu@ucloud.cn> wrote:
>> In the flowtables offload all the devices in the flowtables
>> share the same flow_block. An offload rule will be installed on
> "In the flowtables offload all the devices in the flowtables share the"
>
> I am not managing to follow on this sentence. What does "devices in
> the flowtables" mean?


All the devices are added in flowtables.

>
>> all the devices. This scenario is not correct.
> so this is a fix and should go to net, or maybe the code you are fixing
> was only introduced in net-next?

The fix netfilter patch "netfilter: flowtable: restrict flow dissector match on meta ingress device"

now plans to be introduced to nf-next.

http://patchwork.ozlabs.org/patch/1222292/

>
>> It is no problem if there are only two devices in the flowtable,
>> The rule with ingress and egress on the same device can be reject
> nit: rejected
>
>> by driver.
>> But more than two devices in the flowtable will install the wrong
>> rules on hardware.
>>
>> For example:
>> Three devices in a offload flowtables: dev_a, dev_b, dev_c
>>
>> A rule ingress from dev_a and egress to dev_b:
>> The rule will install on device dev_a.
>> The rule will try to install on dev_b but failed for ingress
>> and egress on the same device.
>> The rule will install on dev_c. This is not correct.
>>
>> The flowtables offload avoid this case through restricting the ingress dev
>> with FLOW_DISSECTOR_KEY_META as following patch.
>> http://patchwork.ozlabs.org/patch/1218109/
>>
>> So the mlx5e driver also should support the FLOW_DISSECTOR_KEY_META parse.
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>> v2: remap the patch description
>>
>>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 39 +++++++++++++++++++++++++
>>  1 file changed, 39 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> index 9b32a9c..33d1ce5 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> @@ -1805,6 +1805,40 @@ static void *get_match_headers_value(u32 flags,
>>                              outer_headers);
>>  }
>>
>> +static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
>> +                                  struct flow_cls_offload *f)
>> +{
>> +       struct flow_rule *rule = flow_cls_offload_flow_rule(f);
>> +       struct netlink_ext_ack *extack = f->common.extack;
>> +       struct net_device *ingress_dev;
>> +       struct flow_match_meta match;
>> +
>> +       if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META))
>> +               return 0;
>> +
>> +       flow_rule_match_meta(rule, &match);
>> +       if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
>> +               NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
>> +               return -EINVAL;
>> +       }
>> +
>> +       ingress_dev = __dev_get_by_index(dev_net(filter_dev),
>> +                                        match.key->ingress_ifindex);
>> +       if (!ingress_dev) {
>> +               NL_SET_ERR_MSG_MOD(extack,
>> +                                  "Can't find the ingress port to match on");
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (ingress_dev != filter_dev) {
>> +               NL_SET_ERR_MSG_MOD(extack,
>> +                                  "Can't match on the ingress filter port");
>> +               return -EINVAL;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>>  static int __parse_cls_flower(struct mlx5e_priv *priv,
>>                               struct mlx5_flow_spec *spec,
>>                               struct flow_cls_offload *f,
>> @@ -1825,6 +1859,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>>         u16 addr_type = 0;
>>         u8 ip_proto = 0;
>>         u8 *match_level;
>> +       int err;
>>
>>         match_level = outer_match_level;
>>
>> @@ -1868,6 +1903,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>>                                                     spec);
>>         }
>>
>> +       err = mlx5e_flower_parse_meta(filter_dev, f);
>> +       if (err)
>> +               return err;
>> +
>>         if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
>>                 struct flow_match_basic match;
>>
>> --
>> 1.8.3.1
>>

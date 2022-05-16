Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F335284D5
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 14:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbiEPM6n convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 May 2022 08:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242555AbiEPM6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 08:58:42 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8815A39692
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 05:58:39 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-26-egN1LxiiP3-10YOmmmgPPQ-1; Mon, 16 May 2022 13:58:36 +0100
X-MC-Unique: egN1LxiiP3-10YOmmmgPPQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Mon, 16 May 2022 13:58:35 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Mon, 16 May 2022 13:58:35 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: UDP receive performance drop since 3.10
Thread-Topic: UDP receive performance drop since 3.10
Thread-Index: AdhpCyTkrjZFcHw/Sxqn9+GJ1PBwvw==
Date:   Mon, 16 May 2022 12:58:35 +0000
Message-ID: <d11a2ce6ed394acd8c6da29d0358f7ce@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've noticed a doubling in the cpu cost of udp processing
between a RHEL 3.10 kernel and a 5.18-rc6 one.

This is (probably) all within ip_rcv().

I'm testing very high rate UDP receive of RTP audio.
(The target is 500000 udp/sec.)
I've enable RPS so that ip_rcv() runs on different multiple
cpus from the ethernet code.
(RSS on the BCM5720 (tg3) doesn't seem to work very well.)

On the 3.10 kernel the 'RPS' cpu show about 5% 'soft int' time.
With 5.10 this has doubled to 10% for much the same test.

The ftrace for a single packet shows a lot of extra code.
With a RHEL 3.10 kernel the trace is quite short:

                 /* netif_receive_skb: dev=em2 skbaddr=ffff99c3ee5ae000 len=200 */
                 ip_rcv() {
                   ip_rcv_finish() {
    0.483 us         udp_v4_early_demux();
                     ip_route_input_noref() {
                       ip_route_input_slow() {
    2.036 us             fib_table_lookup();
                         fib_validate_source() {
                           __fib_validate_source.isra.13() {
    0.646 us                 fib_table_lookup();
    1.589 us               }
    2.610 us             }
    6.820 us           }
    7.755 us         }
                     ip_local_deliver() {
                       ip_local_deliver_finish() {
    0.250 us             raw_local_deliver();
                         udp_rcv() {
                           __udp4_lib_rcv() {
                             __udp4_lib_lookup() {
    0.063 us                   compute_score();
    0.097 us                   compute_score();
    1.496 us                 }
                             udp_queue_rcv_skb() {
                               sk_filter_trim_cap() {
                                 security_sock_rcv_skb() {
    0.066 us                       cap_socket_sock_rcv_skb();
    1.024 us                     }
    1.836 us                   }
    0.093 us                   ipv4_pktinfo_prepare();
                               __udp_enqueue_schedule_skb() {
    0.066 us                     _raw_spin_lock();
                                 sock_def_readable() {
                                   __wake_up_sync_key() {
                                     __wake_up_common_lock() {
    0.194 us                           _raw_spin_lock_irqsave();
                                       __wake_up_common() {
                                         ep_poll_callback() {
    0.184 us                               _raw_spin_lock_irqsave();
    0.084 us                               _raw_spin_unlock_irqrestore();
    2.009 us                             }
    3.264 us                           }
    0.087 us                           _raw_spin_unlock_irqrestore();
    5.579 us                         }
    6.311 us                       }
    7.241 us                     }
    8.833 us                   }
  + 12.948 us                }
  + 16.365 us              }
  + 17.280 us            }
  + 19.900 us          }
  + 20.673 us        }
  + 31.519 us      }
  + 32.534 us    }

Whereas 5.18 has a much longer trace:
                ip_rcv() {
   0.668 us       ip_rcv_core();
                  ip_rcv_finish_core.constprop.0() {
   1.155 us         udp_v4_early_demux();
                    ip_route_input_noref() {
   0.306 us           __rcu_read_lock();
                      ip_route_input_rcu() {
                        ip_route_input_slow() {
                          make_kuid() {
   0.441 us                 map_id_range_down();
   1.231 us               }
   0.307 us               __rcu_read_lock();
                          fib_table_lookup() {
   1.268 us                 fib_lookup_good_nhc();
   2.736 us               }
   0.307 us               __rcu_read_unlock();
                          fib_validate_source() {
                            __fib_validate_source() {
                              make_kuid() {
   0.304 us                     map_id_range_down();
   0.931 us                   }
   0.304 us                   __rcu_read_lock();
                              fib_table_lookup() {
   0.493 us                     fib_lookup_good_nhc();
   1.405 us                   }
   0.393 us                   __rcu_read_unlock();
   0.390 us                   fib_info_nh_uses_dev();
   5.457 us                 }
   6.327 us               }
 + 13.726 us            }
 + 14.727 us          }
   0.407 us           __rcu_read_unlock();
 + 16.673 us        }
 + 19.389 us      }
                  ip_local_deliver() {
                    ip_local_deliver_finish() {
   0.376 us           __rcu_read_lock();
                      ip_protocol_deliver_rcu() {
   0.434 us             raw_local_deliver();
                        udp_rcv() {
                          __udp4_lib_rcv() {
                            __udp4_lib_lookup() {
   0.326 us                   udp4_lib_lookup2.isra.0();
   0.928 us                   udp4_lib_lookup2.isra.0();
   2.413 us                 }
                            udp_unicast_rcv_skb() {
                              udp_queue_rcv_skb() {
                                udp_queue_rcv_one_skb() {
                                  sk_filter_trim_cap() {
   0.440 us                         security_sock_rcv_skb();
                                    sk_filter_trim_cap.part.0() {
   0.297 us                           __rcu_read_lock();
   0.310 us                           __rcu_read_unlock();
   1.531 us                         }
   3.277 us                       }
   0.334 us                       skb_pull_rcsum();
   0.310 us                       ipv4_pktinfo_prepare();
                                  __udp_enqueue_schedule_skb() {
                                    _raw_spin_lock() {
   0.334 us                           preempt_count_add();
   0.938 us                         }
                                    _raw_spin_unlock() {
   0.303 us                           preempt_count_sub();
   0.908 us                         }
                                    sock_def_readable() {
   0.307 us                           __rcu_read_lock();
                                      __wake_up_sync_key() {
                                        __wake_up_common_lock() {
                                          _raw_spin_lock_irqsave() {
   0.326 us                                 preempt_count_add();
   0.951 us                               }
                                          __wake_up_common() {
                                            ep_poll_callback() {
                                              _raw_read_lock_irqsave() {
   0.330 us                                     preempt_count_add();
   1.152 us                                   }
   0.614 us                                   __rcu_read_lock();
   0.323 us                                   __rcu_read_unlock();
                                              _raw_read_unlock_irqrestore() {
   0.380 us                                     preempt_count_sub();
   0.995 us                                   }
   5.410 us                                 }
   6.741 us                               }
                                          _raw_spin_unlock_irqrestore() {
   0.317 us                                 preempt_count_sub();
   1.094 us                               }
   9.994 us                             }
 + 10.806 us                          }
   0.327 us                           __rcu_read_unlock();
 + 12.809 us                        }
 + 16.182 us                      }
 + 22.153 us                    }
 + 22.769 us                  }
 + 23.528 us                }
 + 27.878 us              }
 + 28.646 us            }
 + 30.476 us          }
   0.324 us           __rcu_read_unlock();
 + 32.398 us        }
 + 33.168 us      }
 + 54.976 us    }

Now I know the cost of ftrace is significant (and seems to be
higher in 5.18) but there also seems to be a lot more code.
As well as the extra rcu locks (which are probably mostly ftrace
overhead, a few other things stick out:

1) The sock_net_uid(net, NULL) calls.
   These are make_kuid(net->user_ns, 0) - so pretty much constant.
   They seem to end up in a loop in map_id_range_down_base().
   All looks expensive in the default network namespace where
   0 maps to 0.

2) Extra code in fib_lookup().

3) A lot more locking in ep_poll_callback().

The 5.18 kernel also seems to have CONFIG_DEBUG_PREEMPT set.
I can't find the Kconfig entry for it.
It doesn't exist in the old .config at all.
So I'm not sure why 'make oldconfig' picked it up.

The other possibility is that the extra code is tick_nohz_idle_exit().
The 3.10 trace is from a non-RPS config so I can't compare it.

I'm going to disable CONFIG_DEBUG_PREEMPT to see how much
difference it makes.
Any idea if any other debug options will have got picked up?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

